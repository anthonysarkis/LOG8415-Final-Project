cd ~
wget https://dev.mysql.com/get/Downloads/MySQL-Cluster-7.6/mysql-cluster-community-management-server_7.6.6-1ubuntu18.04_amd64.deb
sudo dpkg -i mysql-cluster-community-management-server_7.6.6-1ubuntu18.04_amd64.deb
sudo mkdir /var/lib/mysql-cluster

sudo nano /var/lib/mysql-cluster/config.ini
# Paste config.ini file

sudo apt-update
sudo apt install libncurses5
sudo ndb_mgmd -f /var/lib/mysql-cluster/config.ini
sudo pkill -f ndb_mgmd

sudo nano /etc/systemd/system/ndb_mgmd.service
# Paste ndb_mgmd.service file

sudo systemctl daemon-reload
sudo systemctl enable ndb_mgmd
sudo systemctl start ndb_mgmd
sudo systemctl status ndb_mgmd

sudo ufw allow from ip-172-31-38-95.ec2.internal
sudo ufw allow from ip-172-31-32-143.ec2.internal
sudo ufw allow from ip-172-31-34-143.ec2.internal

# After setting up and configuring Slave nodes

cd ~
wget https://dev.mysql.com/get/Downloads/MySQL-Cluster-7.6/mysql-cluster_7.6.6-1ubuntu18.04_amd64.deb-bundle.tar
mkdir install
tar -xvf mysql-cluster_7.6.6-1ubuntu18.04_amd64.deb-bundle.tar -C install/
cd install
sudo apt update
sudo apt install libaio1 libmecab2
# Password: root
sudo dpkg -i mysql-common_7.6.6-1ubuntu18.04_amd64.deb
sudo dpkg -i mysql-cluster-community-client_7.6.6-1ubuntu18.04_amd64.deb
sudo dpkg -i mysql-client_7.6.6-1ubuntu18.04_amd64.deb
sudo dpkg -i mysql-cluster-community-server_7.6.6-1ubuntu18.04_amd64.deb
sudo dpkg -i mysql-server_7.6.6-1ubuntu18.04_amd64.deb

sudo nano /etc/mysql/my.cnf
# Paste master-mb.cnf file

sudo systemctl restart mysql
sudo systemctl enable mysql

mysql -u root -p
SHOW ENGINE NDB STATUS \G
exit

ndb_mgm
show