import pymysql
import sys
import math
import random
import optparse
from pythonping import ping
from sshtunnel import SSHTunnelForwarder


master_public_ip = "52.91.88.15"
slaves_public_ip = ["3.81.35.241", "34.227.73.188", "35.171.86.118"]


def execute(slave_ip, master_ip, query):
    with SSHTunnelForwarder(slave_ip, ssh_username='ubuntu', ssh_pkey='vockey.pem', remote_bind_address=(master_ip, 3306)) as tunnel:
        conn = pymysql.connect(host=master_ip, user='user', password='password', db='sakila', port=3306, autocommit=True)
        print(conn)
        cursor = conn.cursor()
        operation = query
        cursor.execute(operation)
        print(cursor.fetchall())
        return conn


def ping_host(host):
    return ping(target=host, count=1, timeout=2).rtt_avg_ms


def get_fastest_slave(slaves):
    min = math.inf
    best_slave = None
    for slave in slaves:
        ping_time = ping_host(slave)
        print("Ping Time: ", ping_time)
        if ping_time < min:
            best_slave = slave
            min = ping_time
    print('Lowest Ping :', min)
    return best_slave


def direct_hit(master, query):
    print('Sending Request to : ', master)
    execute(master, master, query)


def random_hit(slaves, master, query):
    slave = random.choice(slaves)
    print('Sending Request to : ', slave)
    execute(slave, master, query)


def customized_hit(slaves, master, query):
    fastest_slave = get_fastest_slave(slaves)
    print('Sending Request to : ', fastest_slave)
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
