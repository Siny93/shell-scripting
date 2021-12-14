#!/bin/bash
source components/common.sh


#echo -e "  --------<<<<<<<<< MongoDB setup >>>>>>>----------"
#
#
#
#curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>${LOG_FILE}
#STAT_CHECK $? "Download mongodb repo"
#
#yum install -y mongodb-org &>>${LOG_FILE}
#STAT_CHECK $? "Install mongodb"
#
#sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${LOG_FILE}
#STAT_CHECK $? "Update mongodb service"
#
#systemctl enable mongod &>>${LOG_FILE} && systemctl start mongod &>>${LOG_FILE}
#STAT_CHECK $? "Start mongodb service"
#
#DOWNLOAD mongodb
#
#cd /tmp/mongodb-main
#mongo < catalogue.js &>>${LOG_FILE} && mongo < users.js &>>${LOG_FILE}
#STAT_CHECK $? "Load schema"
#
#
#### Redis setup
#echo -e "  --------<<<<<<<<< Redis setup >>>>>>>----------"
#
#
#curl -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>>${LOG_FILE}
#STAT_CHECK $? "download redis"
#
#yum install redis -y &>>${LOG_FILE}
#STAT_CHECK $? "install redis"
#
#sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf &>>${LOG_FILE}
#STAT_CHECK $? "update redis config"
#
#systemctl enable redis &>>${LOG_FILE} && systemctl start redis &>>${LOG_FILE}
#STAT_CHECK $? "update redis"
#
#
#### Rabbitmq setup
#echo -e "  --------<<<<<<<<< RabbitMQ setup >>>>>>>----------"
#
#curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>${LOG_FILE}
#STAT_CHECK $? "download rabbitmq repo"
#
#yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm rabbitmq-server -y &>>${LOG_FILE}
#STAT_CHECK $? "install rabbitmq and erlang"
#
#
#systemctl enable rabbitmq-server &>>${LOG_FILE} && systemctl start rabbitmq-server &>>${LOG_FILE}
#
#rabbitmqctl list_users | grep roboshop &>>${LOG_FILE}
#
#if [ $? -ne 0 ]; then
#
#rabbitmqctl add_user roboshop roboshop123 &>>${LOG_FILE}
#STAT_CHECK $? "create app user in rabbitmq"
#fi
#
#
#rabbitmqctl set_user_tags roboshop administrator &>>${LOG_FILE} && rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${LOG_FILE}
#STAT_CHECK $? "configure app user permissions"

### Mysql setup
echo -e "  --------<<<<<<<<< Mysql setup >>>>>>>----------"

curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>${LOG_FILE}
STAT_CHECK $? "configure yum repos"

yum install mysql-community-server -y &>>${LOG_FILE}
STAT_CHECK $? "installing mysql"

systemctl enable mysqld &>>${LOG_FILE} && systemctl start mysqld &>>${LOG_FILE}
STAT_CHECK $? "start mysql"

DEFAULT_PASSWORD=$(grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}')
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'RoboShop@1';" >/tmp/pass.sql
mysql -uroot -p"${DEFAULT_PASSWORD}" </tmp/pass.sql



#Now a default root password will be generated and given in the log file.
## grep temp /var/log/mysqld.log
#
#Next, We need to change the default root password in order to start using the database service.
## mysql_secure_installation
#
#You can check the new password working or not using the following command.
#
## mysql -u root -p
#
#Run the following SQL commands to remove the password policy.
#> uninstall plugin validate_password;
#Setup Needed for Application.
#As per the architecture diagram, MySQL is needed by
#
#Shipping Service
#So we need to load that schema into the database, So those applications will detect them and run accordingly.
#
#To download schema, Use the following command
#
## curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"
#Load the schema for Services.
#
## cd /tmp
## unzip mysql.zip
## cd mysql-main
## mysql -u root -pRoboShop@1 <shipping.sql