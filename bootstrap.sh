sudo apt-get update

DATABASEUSER="vagrant"
DATABASENAME="vagrant"
DATABASEPASSWORD="vagrant"

DBUSER="vagrant"
DBNAME="vagrant"
DBPASSWD="vagrant"

sudo debconf-set-selections <<EOF
mysql-server	mysql-server/root_password password $DATABASEPASSWORD
mysql-server	mysql-server/root_password_again password $DATABASEPASSWORD
bconfig-common	dbconfig-common/mysql/app-pass password $DATABASEPASSWORD
dbconfig-common	dbconfig-common/mysql/admin-pass password $DATABASEPASSWORD
dbconfig-common	dbconfig-common/password-confirm password $DATABASEPASSWORD
dbconfig-common	dbconfig-common/app-password-confirm password $DATABASEPASSWORD
EOF

#install mysql and admin interface
apt-get -y install mysql-server

# Creating database
mysql -uroot -p$DATABASEPASSWORD -e "CREATE DATABASE $DATABASENAME" 
mysql -uroot -p$DATABASEPASSWORD -e "grant all privileges on $DATABASENAME.* to '$DATABASEUSER'@'%' identified by '$DATABASEPASSWORD'"

# update mysql conf file to allow remote access to the db
sudo sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf

# restart service to apply confs
sudo service mysql restart