#!/bin/bash
USER_UID=$(id -u)
if [ "${USER_UID}" -ne 0 ]; then
  echo -e "\e[1;31mYou should be root user to perform this script\e[0m"
  exit
fi

