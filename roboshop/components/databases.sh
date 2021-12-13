#!/bin/bash

echo -e "  --------<<<<<<<<< MongoDB setup >>>>>>>----------"


source components/common.sh
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>${LOG_FILE}
STAT_CHECK $? "Download mongodb repo"

yum install -y mongodb-org &>>${LOG_FILE}
STAT_CHECK $? "Install mongodb"

sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${LOG_FILE}
STAT_CHECK $? "Update mongodb service"

systemctl enable mongod &>>${LOG_FILE} && systemctl start mongod &>>${LOG_FILE}
STAT_CHECK $? "Start mongodb service"

DOWNLOAD mongodb

cd /tmp/mongodb-main
mongo < catalogue.js &>>${LOG_FILE} && mongo < users.js &>>${LOG_FILE}
STAT_CHECK $? "Load schema"


### Redis setup
echo -e "  --------<<<<<<<<< Redis setup >>>>>>>----------"


curl -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>>${LOG_FILE}
STAT_CHECK $? "download redis"

yum install redis -y &>>${LOG_FILE}
STAT_CHECK $? "install redis"

sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf &>>${LOG_FILE}
STAT_CHECK $? "update redis config"

systemctl enable redis &>>${LOG_FILE} && systemctl start redis &>>${LOG_FILE}
STAT_CHECK $? "update redis"


### Rabbitmq setup
echo -e "  --------<<<<<<<<< RabbitMQ setup >>>>>>>----------"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>${LOG_FILE}
STAT_CHECK $? "download rabbitmq repo"

yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm rabbitmq-server -y &>>${LOG_FILE}
STAT_CHECK $? "install rabbitmq and erlang"


systemctl enable rabbitmq-server &>>${LOG_FILE} && systemctl start rabbitmq-server &>>${LOG_FILE}

rabbitmqctl list_users | grep roboshop &>>${LOG_FILE}

if [ $? -ne 0 ]; then

rabbitmqctl add_user roboshop roboshop123 &>>${LOG_FILE}
STAT_CHECK $? "create app user in rabbitmq"
fi


rabbitmqctl set_user_tags roboshop administrator &>>${LOG_FILE} && rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${LOG_FILE}
STAT_CHECK $? "configure app user permissions"