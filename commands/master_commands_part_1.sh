#!/bin/bash

MASTER="ip-172-31-44-66.ec2.internal"
SLAVE_1="ip-172-31-36-255.ec2.internal"
SLAVE_2="ip-172-31-39-191.ec2.internal"
SLAVE_3="ip-172-31-38-13.ec2.internal"

# Install Dependancies
sudo apt update && sudo apt install libaio1 libmecab2 libncurses5 dos2unix sysbench expect -y
cd ~

# Install MySQL
sudo wget https://dev.mysql.com/get/Downloads/MySQL-Cluster-7.6/mysql-cluster-community-management-server_7.6.6-1ubuntu18.04_amd64.deb
sudo dpkg -i mysql-cluster-community-management-server_7.6.6-1ubuntu18.04_amd64.deb
sudo mkdir /var/lib/mysql-cluster


# Create config file
cat <<EOF >config.ini
[ndbd default]
# Options affecting ndbd processes on all data nodes:
NoOfReplicas=3	# Number of replicas
[ndb_mgmd]
# Management process options:
hostname=$MASTER  # Hostname of the manager
datadir=/var/lib/mysql-cluster          # Directory for the log files
NodeId=1
[ndbd]
hostname=$SLAVE_1   # Hostname/IP of the first data node
NodeId=2			                    # Node ID for this data node
datadir=/usr/local/mysql/data	        # Remote directory for the data files
[ndbd]
hostname=$SLAVE_2  # Hostname/IP of the second data node
NodeId=3			                    # Node ID for this data node
datadir=/usr/local/mysql/data	        # Remote directory for the data files
[ndbd]
hostname=$SLAVE_3  # Hostname/IP of the second data node
NodeId=4			                    # Node ID for this data node
datadir=/usr/local/mysql/data	        # Remote directory for the data files
[mysqld]
# SQL node options:
hostname=$MASTER
EOF

sudo dos2unix config.ini
sudo cp config.ini /var/lib/mysql-cluster/

# Create service file
cat <<EOF >ndb_mgmd.service
[Unit]
Description=MySQL NDB Cluster Management Server
After=network.target auditd.service
[Service]
Type=forking
ExecStart=/usr/sbin/ndb_mgmd -f /var/lib/mysql-cluster/config.ini
ExecReload=/bin/kill -HUP \$MAINPID
KillMode=process
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF

sudo dos2unix config.ini
sudo cp ndb_mgmd.service /etc/systemd/system/

# Start service
sudo systemctl daemon-reload 
sudo systemctl enable ndb_mgmd 
sudo systemctl start ndb_mgmd
sudo systemctl status ndb_mgmd