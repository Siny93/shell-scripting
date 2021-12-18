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
STAT_CHECK $? "copy nginx configuration file"

sed -i -e '/catalogue/ s/localhost/catalogue.roboshop.internal/' \
       -e '/cart/ s/localhost/cart.roboshop.internal/' \
       -e '/user/ s/localhost/user.roboshop.internal/' \
       -e '/shipping/ s/localhost/shipping.roboshop.internal/' \
       -e '/payment/ s/localhost/payment.roboshop.internal/' /etc/nginx/default.d/roboshop.conf
  STAT_CHECK $? "update nginx configuration file"

systemctl enable nginx &>>${LOG_FILE} && systemctl start nginx &>>${LOG_FILE}
STAT_CHECK $? "restart nginx"
