echo frontend setup

STAT_CHECK(){
  if [ $1 -ne 0 ]; then
    echo "${2}"
    exit 1
  fi
}
yum install nginx -y
STAT_CHECK $? "nginx installation failed"



curl -f -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zi"
STAT_CHECK $? "download frontend failed"

cd /usr/share/nginx/html
rm -rf *
unzip /tmp/frontend.zip
mv frontend-main/* .
mv static/* .
rm -rf frontend-master static README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf

systemctl enable nginx
systemctl start nginx

