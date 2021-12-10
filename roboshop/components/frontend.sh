echo frontend setup

STAT_CHECK(){
  if [ $1 -ne 0 ]; then
    echo "nginx install failed"
    exit 1
  fi
}
yum install nginx -y



curl -f -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zi"


cd /usr/share/nginx/html
rm -rf *
unzip /tmp/frontend.zip
mv frontend-main/* .
mv static/* .
rm -rf frontend-master static README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf

systemctl enable nginx
systemctl start nginx

