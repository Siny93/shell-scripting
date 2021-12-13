echo frontend setup

source components/common.sh

yum install nginx -y &>>${LOG_FILE}
STAT_CHECK $? "nginx installation"

DOWNLOAD frontend

rm -rf /usr/share/nginx/html/*
STAT_CHECK $? "remove old html files"



cd /tmp/frontend-main/static/ && cp -r * /usr/share/nginx/html/
STAT_CHECK $? "copying frontend content"

cp /tmp/frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf
STAT_CHECK $? "update nginx configuration file"


systemctl enable nginx &>>${LOG_FILE} && systemctl start nginx &>>${LOG_FILE}
STAT_CHECK $? "restart nginx"
