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

    if [[ $last_version == $actual_version ]]; then
      echo "tests not executed, last_version found on metadata.json is equal HEAD"
    else
      echo -e "Build tag\n"
      # put hash on tag
      tag=$(echo "$implementation" | tr '[:upper:]' '[:lower:]')
      tag="$tag-$actual_version"
      docker build -t$tag .
      echo "------------------------------"
      mkdir -p "output-$tag/"
      echo -e "Runing tests, it may take some time...\n"
      docker run --rm \
        -v "$root/inputs/:/inputs" \
        -v "$PWD/output-$tag/:/app/output_bench/" \
        $tag

      echo "New folder: output-$tag/"
      echo "------------------------------"
    fi

    echo "=============================================================================================="
    cd ..
  done

  cd ../../
done

