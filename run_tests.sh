#!/bin/bash

# Load variables
source common_resources.sh

if [ "$#" -ne 2 ]; then
  echo "Error: This script expects exactly two arguments."
  echo "Usage: run_tests.sh algorithmName implementation"
  echo "-> algorithmName = [${valid_algorithms[@]}], accept value 'all'"
  echo "-> implementation = '[some-language]-[some-github-user]' i.e. 'python-SGeetansh', accept value 'all'"
  exit 1
fi

# Assign the received arguments to variables
list_algo_run=$1
list_implementation=$2

if [ $list_algo_run == "all" ]; then
  list_algo_run=$valid_algorithms
fi


for algorithmName in ${list_algo_run[@]}
do
  cd "algorithms/$algorithmName"

  if [ $list_implementation == "all" ]; then
    list_implementation=$(ls)

  else
    valid_implementations=$(ls)
  fi

  for implementation in ${list_implementation[@]}
  do
    echo "$implementation"
  done

  cd ../../
done

