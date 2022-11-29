import os
import sys
import boto3
import paramiko
from io import StringIO

ec2_client = boto3.client(
    'ec2',
    region_name="us-east-1",
    aws_access_key_id="ASIASDKBNIIVGMNWX45Z",
    aws_secret_access_key="n9ZyMlEvy/iNY7Xuqih9LWRynYdZUngN3oakV42r",
    aws_session_token="FwoGZXIvYXdzEF0aDG2LPR8g9w8RfMclFCLBAVCgmFDl61Nos4IvxTqJWNPFBPrJDams6lxOX6BitSP8j1Nn3ADe4hcqh5ARv+sXQc6IqWTiYLeW710tZqN1l0S5z1apx8B9jg43X2x2PE2XsRVS3z4Cilc+b8owFWnSlL/miAdQkcxwDkOGbarpSZe53lQCpBJg0yxs0fGzilMkTws0+ZPI9HmwN1Pywzn/Qx+8BkC54+E53pyoHlQCA1rdDWEfg9opIR09lFK8kPwplBVXTEOxHf3J8jFodntOiEoox8iZnAYyLSwaps5I6rAaliJMQGJjRdBY7GJottkJaCPCHILYIZOnzBRTEva/U1xlNIktKA=="
)

target_instances = ec2_client.describe_instances(
    Filters=[
        {'Name': 'tag:Name', 'Values': ['Proxy', 'Master', 'Slave1', 'Slave2', 'Slave3']}
    ]
)

ec2_instances = dict()
for each_instance in target_instances['Reservations']:
    for found_instance in each_instance['Instances']:
        
        if found_instance['State']['Name'] == 'terminated':
            continue
        
        name = found_instance['Tags'][0]['Value']
        public_dns_name = found_instance['PublicDnsName']
        # private_ip = found_instance['PrivateIpAddress']

        ec2_instances[name] = public_dns_name

commands = [
    "hostname",
    "ls"
]

ssh_username = "ubuntu"
ssh_key_file = StringIO(open('vockey.pem', 'r').read())
k=paramiko.RSAKey.from_private_key(ssh_key_file)

all_clients = dict()
for instance in ec2_instances:
    client = paramiko.client.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    client.connect(hostname=ec2_instances[instance], username=ssh_username, pkey=k, allow_agent=False, look_for_keys=False)
    all_clients[instance] = client

for client in all_clients:
    ssh_client = all_clients[client]
    for command in commands:
        print("{} instance: running command '{}'".format(client, command))
        stdin, stdout, stderr = ssh_client.exec_command(command)
        print(stdout.read())
        print(stderr.read())
        print()

    ssh_client.close()

















# if __name__ == '__main__':

#     implementation = "Direct hit"

#     if implementation == "Direct hit":
#         print("forward incoming requests to MySQL master node")
#     elif implementation == "Random":
#         print("randomly choose a slave node on MySQL cluster and forward the request to it")
#     elif implementation == "Customized":
#         print("measure ping time and forward the message to one with less response time")
