LOG_FILE=/tmp/roboshop.log
rm -f ${LOG_FILE}
STAT_CHECK()
{
  if [ $1 -ne 0 ]; then
    echo -e "\e[1;31m${2} - failed\e[0m"
    exit 1
  else
    echo -e "\e[1;32m${2} - success\e[0m"
  fi

}

set-hostname -skip-apply ${COMPONENT}

SYSTEMD_SETUP() {
  chown roboshop:roboshop -R /home/roboshop

sed -i -e 's/MONGO_DNSNAME/mongo.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongo.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' -e 's/CARTENDPOINT/cart.roboshop.internal/' -e 's/DBHOST/mysql.roboshop.internal/' /home/roboshop/${component}/systemd.service &>>${LOG_FILE} && mv /home/roboshop/${component}/systemd.service /etc/systemd/system/${component}.service &>>${LOG_FILE}
STAT_CHECK $? "update systemd config file"

systemctl daemon-reload &>>${LOG_FILE} && systemctl start ${component} &>>${LOG_FILE} && systemctl enable ${component} &>>${LOG_FILE}
STAT_CHECK $? "start ${component} service"


}


APP_USER_SETUP() {
  id roboshop &>>${LOG_FILE}
  if [ $? -ne 0 ]; then
    useradd roboshop &>>${LOG_FILE}
    STAT_CHECK $? "Add roboshop user"
  fi

  DOWNLOAD ${component}

}


DOWNLOAD(){
  curl -s -L -o /tmp/${1}.zip "https://github.com/roboshop-devops-project/${1}/archive/main.zip" &>>${LOG_FILE}

  STAT_CHECK $? "download ${1} code"
  cd /tmp
  unzip -o /tmp/${1}.zip &>>${LOG_FILE}
   STAT_CHECK $? "extract ${1} code"
   rm -rf /home/roboshop/${component} && mkdir -p /home/roboshop/${component} && cp -r /tmp/${component}-main/* /home/roboshop/${component} &>>${LOG_FILE}
    STAT_CHECK $? "copy ${component} content"
}

NODEJS(){
component=${1}
yum install nodejs make gcc-c++ -y &>>${LOG_FILE}
STAT_CHECK $? "Install Nodejs"

APP_USER_SETUP




cd /home/roboshop/${component} && npm install --unsafe-perm &>>${LOG_FILE}
STAT_CHECK $? "install nodejs dependencies"



SYSTEMD_SETUP

}

JAVA() {
component=${1}
yum install maven -y &>>${LOG_FILE}
STAT_CHECK $? "installing maven"

APP_USER_SETUP

cd /home/roboshop/${component} && mvn clean package &>>${LOG_FILE} && mv target/${component}-1.0.jar ${component}.jar &>>${LOG_FILE}
STAT_CHECK $? "compile java code"

SYSTEMD_SETUP


}
