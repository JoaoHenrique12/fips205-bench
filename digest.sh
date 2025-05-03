#!/bin/bash

source common_resources.sh

if [ "$#" -ne 2 ]; then
  echo "Error: This script expects exactly two arguments."
  echo "Usage: digest.sh algorithmName language"
  echo "-> algorithmName = [${valid_algorithms[@]}], accept value 'all'"
  echo "-> language = [${valid_languages[@]}], accept value 'all'"
  exit 1
fi

list_algo_run=$1
list_language_run=$2

if [ $list_algo_run == "all" ]; then
  list_algo_run=${valid_algorithms[@]}
fi

if [ $list_language_run == "all" ]; then
  list_language_run=${valid_languages[@]}
fi

cd algorithms/

for algorithm in ${list_algo_run[@]}
do
  cd $algorithm

  for language in ${list_language_run[@]}
  do
    impl_list=$(ls | grep $language)
    for impl in ${impl_list[@]}
    do
      cd $impl
      output_list=$(ls | grep output-)
      for output in ${output_list[@]}
      do
        cd $output
        ./../../../../digest/$language/main.sh
        cd ..
      done
      cd ..
    done
  done
  cd ../
done

cd ../
