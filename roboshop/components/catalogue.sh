#!/bin/bash

echo catalogue setup

source components/common.sh
yum install nodejs make gcc-c++ -y &>>${LOG_FILE}
STAT_CHECK $? "Install Nodejs"


id roboshop &>>${LOG_FILE}
if [ $? -ne 0 ]; then
  useradd roboshop &>>${LOG_FILE}
  STAT_CHECK $? "Add roboshop user"
fi

DOWNLOAD catalogue

rm -rf /home/roboshop/catalogue && mkdir -p /home/roboshop/catalogue && cp -r /tmp/catalogue-main/* /home/roboshop/catalogue &>>${LOG_FILE}
 STAT_CHECK $? "copy catalogue content"

cd /home/roboshop/catalogue && npm install --unsafe-perm &>>${LOG_FILE}
STAT_CHECK $? "install nodejs dependencies"

chown roboshop:roboshop -R /home/roboshop


sed -i -e 's/MONGO_DNSNAME/mongo.roboshop.internal/' /home/roboshop/catalogue/systemd.service &>>${LOG_FILE} && mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>${LOG_FILE}
STAT_CHECK $? "update systemd config file"

systemctl daemon-reload &>>${LOG_FILE} && systemctl start catalogue &>>${LOG_FILE} && systemctl enable catalogue &>>${LOG_FILE}
STAT_CHECK $? "start catalogue service"

