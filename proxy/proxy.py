import requests
import os
import random
from pythonping import ping

implementation = "Direct hit"
query = "SELECT COUNT(*) FROM film;"

headers = {"content-type": "application/json"}
master_url = "http://" + os.environ['master']
slave1_url = "http://" + os.environ['slave1']
slave2_url = "http://" + os.environ['slave2']
slave3_url = "http://" + os.environ['slave3']
all_urls = [master_url, slave1_url, slave2_url, slave3_url]


def ping_host(host):
    return ping(target=host, count=1, timeout=2).rtt_avg_ms

def direct_hit():
    print("forward incoming requests to MySQL master node")
    requests.post(master_url, headers=headers, json=query)

def random_hit():
    print("randomly choose a slave node on MySQL cluster and forward the request to it")
    slave_number = random.randint(1, 3)
    requests.post(all_urls[slave_number], headers=headers, json=query)

def customized_hit():
    print("measure ping time and forward the message to one with less response time")

    response_times = [ping_host(server) for server in all_urls]
    fastest_server = min(range(len(response_times)), key=response_times.__getitem__)

    requests.post(all_urls[fastest_server], headers=headers, json=query)

if __name__ == '__main__':
    if implementation == "Direct hit":
        direct_hit()
    elif implementation == "Random":
        random_hit()
    elif implementation == "Customized":
        customized_hit()
