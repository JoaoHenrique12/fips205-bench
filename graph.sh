#!/bin/bash

source common_resources.sh

if [ "$#" -ne 2 ]; then
  echo "Error: This script expects exactly two arguments."
  echo "Usage: graph.sh algorithmName language"
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

echo "creating graphics for ${list_algo_run[@]}, ${list_language_run[@]}"
echo "turn on virtual environment"
source graph/env/bin/activate
if [[ $? -eq 1 ]]; then
  echo "failed to turn on virtual environment, creating it"
  python3 -m venv graph/env
  source graph/env/bin/activate
  pip3 install -r graph/requirements.txt
  echo "virtual environment activated, dependencies installed"
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
        cd $output/digest
        if [[ $? -eq 1 ]]; then
          echo "digest folder not found, consider use: make digest"
          echo "$PWD"
          continue
        fi
        echo -e "\ncreating graphs for time usage"
        cd cpu
          for file in $(ls)
          do
            echo "$file"
            python3 $root/graph/main.py $file cpu
          done
        cd ..
        echo "---------------------"
        echo "creating graphs for mem usage"
        cd mem
          for file in $(ls)
          do
            echo "$file"
            python3 $root/graph/main.py $file mem
          done
        cd ..

        cd ..
      done
      cd ..
    done
  done
  cd ../
done

cd ../

echo "turn off virtual environment"
deactivate
