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
    valid_implementations=$(ls | tr '\n' ' ')
    if ! is_in_list "$list_implementation" "${valid_implementations[@]}"; then
      echo "implementation <$list_implementation> is not in list [ ${valid_implementations[@]}]"
      exit 1
    fi
  fi

  for implementation in ${list_implementation[@]}
  do
    cd $implementation
    echo "==================== running $algorithmName for implementation $implementation ===================="
    branch=$(cat metadata.json | jq .branch | tr -d '"')
    last_version=$(cat metadata.json | jq .last_version | tr -d '"')

    echo -e "Updating git-repository\n"
    cd git-repository && git checkout $branch && git pull
      actual_version=$(git rev-parse HEAD)
    cd ..
    echo "------------------------------"

    tag=$(echo "$implementation" | tr '[:upper:]' '[:lower:]')
    tag="$tag-$actual_version"
    mkdir "output-$tag/"
    if [ $? -eq 1 ] ; then
      echo "tests not executed, already found folder output-$tag"
      echo "if you want run again this test to this hash consider"
      echo "remove this folder or move it to another direcotry"
    else
      echo -e "Build tag\n"
      docker build -t$tag .
      echo "------------------------------"
      echo -e "Runing tests, it may take some time...\n"
      docker run --rm \
        -v "$root/inputs/:/inputs" \
        -v "$PWD/output-$tag/:/app/output_bench/" \
        $tag

      echo "New folder: output-$tag/"
      echo "------------------------------"
    fi

    jq ".last_version = \"$actual_version\"" "metadata.json" > tmp.json && mv tmp.json "metadata.json"

    echo "=============================================================================================="
    cd ..
  done

  cd ../../
done

