echo frontend setup

yum install nginx -y &>>${LOG_FILE}
STAT_CHECK $? "nginx installation"



curl -f -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"
STAT_CHECK $? "download frontend"

rm -rf /usr/share/nginx/html/*
STAT_CHECK $? "remove old html files"

cd /tmp && unzip -o /tmp/frontend.zip &>>${LOG_FILE}
STAT_CHECK $? "extracting frontend content"

cd /tmp/frontend-main/static/ && cp -r * /usr/share/nginx/html/
STAT_CHECK $? "copying frontend content"

cp /tmp/frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf
STAT_CHECK $? "update nginx configuration file"


systemctl enable nginx &>>${LOG_FILE} && systemctl start nginx &>>${LOG_FILE}
STAT_CHECK $? "restart nginx"
