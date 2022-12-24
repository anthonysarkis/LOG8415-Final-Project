import pymysql
import sys
import math
import random
from pythonping import ping
from sshtunnel import SSHTunnelForwarder


master_public_ip = "107.22.75.54"
slaves_public_ip = ["3.91.51.142", "54.210.78.103", "34.229.196.140"]


def execute(slave_ip, master_ip, query):
    """
    execute uses the SSHTunnelForwarder class from the sshtunnel library to create an SSH tunnel
    between the slave and master servers. This allows the function to execute the MySQL query on 
    the master server as if it were running on the slave server.
    : param slave_ip:    A string that represents the IP address of the slave node
    : param master_ip:   A string that represents the IP address of the master node
    : query:             A string that represents a MySQL query that will be executed on the given server
    : return:             The pymsql connection
    """
    with SSHTunnelForwarder(slave_ip, ssh_username='ubuntu', ssh_pkey='vockey.pem', remote_bind_address=(master_ip, 3306)) as tunnel:
        conn = pymysql.connect(host=master_ip, user='root', password='root', db='sakila', port=3306, autocommit=True)
        cursor = conn.cursor()
        operation = query
        cursor.execute(operation)
        print(cursor.fetchall())
        return conn


def ping_host(host):
    """
    ping_host uses the ping function from the sh library to send a single ICMP echo request 
    to the specified host and returns the average round-trip time (RTT) in milliseconds.
    : param host:    A string that represents the hostname or IP address of the host that is being pinged.
    : return:        The average round-trip time in milliseconds
    """
    return ping(target=host, count=1, timeout=2).rtt_avg_ms


def get_random_slave(slaves):
    """
    get_random_slave selects a random element from the list of slaves and returns it.
    : param slaves:     List of slave instances
    : return:           Random slave from the list of slave nodes            
    """
    return random.choice(slaves)


def get_fastest_slave(slaves):
    """
    get_fastest_slave uses a loop to iterate over the list of slaves and measures the ping time 
    to each slave using the ping_host function. It then stores the slave with the lowest ping time 
    in a variable called fastest_slave and returns it at the end of the function.
    : param slaves:     List of slave instances
    : return:           Fastest slave from the list of slave nodes            
    """
    min = math.inf
    fastest_slave = None

    for slave in slaves:
        ping_time = ping_host(slave)
        print("Slave", slaves_public_ip.index(slave) + 1, "ping time:", ping_time)
        
        if ping_time < min:
            fastest_slave = slave
            min = ping_time
    
    print('Lowest Ping : Slave', slaves_public_ip.index(fastest_slave) + 1, "with", min, '\n')
    return fastest_slave


def direct_hit(master, query):
    """
    direct_hit calls the execute method on the master server
    : param master:     A string that represents the IP address of the master server
    : param query:      The SQL query to execute on the MySQL server          
    """
    print('Request sent to Master -', master, '\n')
    execute(master, master, query)


def random_hit(slaves, master, query):
    """
    random_hit calls the execute method on a random slave server
    : param slaves:     List of slave instances
    : param master:     A string that represents the IP address of the master server
    : param query:      The SQL query to execute on the MySQL server          
    """
    slave = get_random_slave(slaves)
    print('Request sent to Slave', slaves_public_ip.index(slave) + 1, '-', slave, '\n')
    execute(slave, master, query)


def customized_hit(slaves, master, query):
    """
    customized_hit calls the execute method on the fastest slave server
    : param slaves:     List of slave instances
    : param master:     A string that represents the IP address of the master server
    : param query:      The SQL query to execute on the MySQL server          
    """
    fastest_slave = get_fastest_slave(slaves)
    print('Request sent to Slave', slaves_public_ip.index(fastest_slave) + 1, '-', fastest_slave, '\n')
    execute(fastest_slave, master, query)


if __name__ == "__main__":
    implementation = sys.argv[1]
    query = sys.argv[2]

    if implementation == "direct":
        direct_hit(master_public_ip, query)
    elif implementation == "random":
        random_hit(slaves_public_ip, master_public_ip, query)
    elif implementation == "customized":
        customized_hit(slaves_public_ip, master_public_ip, query)
