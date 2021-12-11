echo frontend setup
LOG_FILE=/tmp/roboshop.log
rm -f ${LOG_FILE}
STAT_CHECK(){
  if [ $1 -ne 0 ]; then
    echo -e "\e[1;31m${2} - failed\e[0m"
    exit 1
  else
    echo -e "\e[1;32m${2} - success\e[0m"
  fi

}
yum install nginx -y &>>${LOG_FILE}
STAT_CHECK $? "nginx installation"



curl -f -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"
STAT_CHECK $? "download frontend"

cd /usr/share/nginx/html
rm -rf *
unzip /tmp/frontend.zip
mv frontend-main/* .
mv static/* .
rm -rf frontend-master static README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf

systemctl enable nginx
systemctl start nginx

