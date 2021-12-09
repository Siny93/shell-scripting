#!/bin/bash/
read -p 'enter your age: ' age
if [ "${age}" -lt 18 ]; then
  echo u are minor
else
  echo u are major
fi