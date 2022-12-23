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
3. mysql -u root -p

### To test Sakile
1. SOURCE /tmp/sakila-db/sakila-schema.sql;
2. SOURCE /tmp/sakila-db/sakila-data.sql;
3. USE sakila;
4. SHOW FULL TABLES;

### To run sysbench
1. chmod 777 sysbench.sh
2. ./sysbench.sh

### On the Standalone instance:
1. git clone https://github.com/anthonysarkis/LOG8415-Final-Project.git
2. cd LOG8415-Final-Project/commands/
3. chmod 777 install_sakila_commands.sh
4. ./install_sakila_commands.sh
5. chmod 777 standalone_sysbench.sh
6. ./standalone_sysbench.sh

## Proxy

### On the Master instance
1. CREATE USER 'usrname'@'proxy_public_ip' IDENTIFIED BY 'password';
2. GRANT ALL PRIVILEGES ON * . * TO 'usrname'@'proxy_public_ip';

### On the Proxy instance
1. git clone https://github.com/anthonysarkis/LOG8415-Final-Project.git
2. cd LOG8415-Final-Project/proxy/
3. python3 app.py direct "SELECT COUNT(*) FROM film;"