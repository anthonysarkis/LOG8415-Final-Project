wget https://downloads.mysql.com/docs/sakila-db.tar.gz
tar -xvzf sakila-db.tar.gz
cp -r sakila-db /tmp/

mysql -u root -proot
SOURCE /tmp/sakila-db/sakila-schema.sql;
SOURCE /tmp/sakila-db/sakila-data.sql;
USE sakila;
SHOW FULL TABLES;

exit