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

DOWNLOAD(){
  curl -s -L -o /tmp/${1}.zip "https://github.com/roboshop-devops-project/${1}/archive/main.zip" &>>${LOG_FILE}

  STAT_CHECK $? "download ${1} code"
  cd /tmp
  unzip -o /tmp/${1}.zip &>>${LOG_FILE}
   STAT_CHECK $? "extract ${1} code"
}
