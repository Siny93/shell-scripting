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
}

sample
sample1
sample2 123 xyz

