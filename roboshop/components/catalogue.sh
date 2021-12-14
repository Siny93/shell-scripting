#!/bin/bash

echo catalogue setup

source components/common.sh
yum install nodejs make gcc-c++ -y &>>${LOG_FILE}
STAT_CHECK $? "Install Nodejs"


echo id roboshop
#useradd roboshop &>>${LOG_FILE}
#STAT_CHECK $? "Add roboshop user"

#DOWNLOAD catalogue
