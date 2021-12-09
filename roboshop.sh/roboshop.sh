#!/bin/bash
USER_UID=$(id -u)
if [ "${USER-ID}" -ne 0 ]; then
  echo -e "\e[1;31mYou should be root user to perform this script\e[0m"
  exit
fi

COMPONENT=$1

if [ -z "$COMPONENT" ]; then
  echo -e "\e[1;31mcomponent input missing\e[0m"
  exit
fi

if [ ! -e components/${COMPONENT}.sh ]; then
  echo -e "\e[1;31mgiven script doesnot exist\e[0m"
  exit
fi

bash components/${COMPONENTS}.sh
