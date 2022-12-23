import pymysql
import sys
import math
import random
from pythonping import ping
from sshtunnel import SSHTunnelForwarder


master_public_ip = "107.22.75.54"
slaves_public_ip = ["3.91.51.142", "54.210.78.103", "34.229.196.140"]


def execute(slave_ip, master_ip, query):
    with SSHTunnelForwarder(slave_ip, ssh_username='ubuntu', ssh_pkey='vockey.pem', remote_bind_address=(master_ip, 3306)) as tunnel:
        conn = pymysql.connect(host=master_ip, user='root', password='root', db='sakila', port=3306, autocommit=True)
        cursor = conn.cursor()
        operation = query
        cursor.execute(operation)
        print(cursor.fetchall())
        return conn


def ping_host(host):
    return ping(target=host, count=1, timeout=2).rtt_avg_ms


def get_random_slave(slaves):
    return random.choice(slaves)


def get_fastest_slave(slaves):
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
    print('Request sent to Master -', master, '\n')
    execute(master, master, query)


def random_hit(slaves, master, query):
    slave = get_random_slave(slaves)
    print('Request sent to Slave', slaves_public_ip.index(slave) + 1, '-', slave, '\n')
    execute(slave, master, query)


def customized_hit(slaves, master, query):
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
