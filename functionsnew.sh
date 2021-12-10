#!/bin/bash

## declaring functions

function sample(){
  echo one
  echo two
}

sample2()
{
  echo three
  echo four
}

sample
sample2
