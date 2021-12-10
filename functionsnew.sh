#!/bin/bash

## declaring functions

function sample(){
  echo one
  echo two
}

sample1()
{
  echo three
  echo four
}

sample2(){
  echo first argument = $1
  echo number of arguments = $#
  a=300
  echo a in function = ${a}
  b=400
}

## main pgm


a=100

sample2 123 xyz

echo ${b}

