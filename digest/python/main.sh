#!/bin/bash

#TODO: remove me
rm -rf digest

mkdir digest

if [[ $? -eq 0 ]]; then
  # digest mem
  cp -r bench_mem digest/mem

  cd digest/mem
    $root/digest/python/digest_mem_one_signature.sh
    $root/digest/python/digest_mem_many_signatures.sh

    ## cleaning temp files
    ls | grep -Ev "^(sign|verify)" | xargs rm
  cd ../../

  # digest cpu
  cp -r bench_cpu digest/cpu
  cd digest/cpu
    echo "transforming .prof files to .csv"
    for file_prof in $(ls)
    do
      python3 $root/digest/python/transform_prof_to_csv.py $file_prof
      rm $file_prof
    done
  
  cd ../../
fi
