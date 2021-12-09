#!/bin/bash/
read -p 'enter your age: ' age
if [ "${age}" -lt 18 ]; then
  echo u are minor
elif [ "${age}" -gt 60 ]; then
  echo u are senior citizen
else
  echo u are major
fi