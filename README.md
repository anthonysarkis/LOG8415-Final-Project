# LOG8415 Final Project

First run main.tf script to deploy EC2 instances.

## MySQL

### On the Master instance:
1. git clone https://github.com/anthonysarkis/LOG8415-Final-Project.git
2. cd LOG8415-Final-Project/commands/
3. chmod 777 master_commands_part_1.sh
4. ./master_commands_part_1.sh

### On all three Slave instances:
1. git clone https://github.com/anthonysarkis/LOG8415-Final-Project.git
2. cd LOG8415-Final-Project/commands/
3. chmod 777 slave_commands.sh
4. ./slave_commands.sh

### On the Master instance:
1. chmod 777 master_commands_part_2.sh
2. ./master_commands_part_2.sh
3. cd ~
4. cd install/
5. sudo dpkg -i mysql-cluster-community-server_7.6.6-1ubuntu18.04_amd64.deb
6. sudo dpkg -i mysql-server_7.6.6-1ubuntu18.04_amd64.deb
7. sudo nano /etc/mysql/my.cnf
8. Append the content of mast-my.cnf
9. sudo systemctl restart mysql
10. sudo systemctl enable mysql

### To install Sakila
1. chmod 777 install_sakila_commands.sh
2. ./install_sakila_commands.sh

### To run sysbench
1. chmod 777 sysbench.sh
2. ./sysbench.sh

### On the Standalone instance:
1. git clone https://github.com/anthonysarkis/LOG8415-Final-Project.git
2. cd LOG8415-Final-Project/commands/
3. chmod 777 standalone_commands.sh
4. ./standalone_commands.sh

## Proxy

Proxy
