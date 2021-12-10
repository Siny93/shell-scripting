echo frontend setup


yum install nginx -y
if [ $? -ne 0 ]; then
  echo "nginx install failed"
  exit 1
fi


curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zi"
if [ $? -ne 0 ]; then
  echo "download failed"
  exit 1
fi

cd /usr/share/nginx/html
rm -rf *
unzip /tmp/frontend.zip
mv frontend-main/* .
mv static/* .
rm -rf frontend-master static README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf

systemctl enable nginx
systemctl start nginx

