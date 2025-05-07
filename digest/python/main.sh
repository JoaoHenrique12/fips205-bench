#!/bin/bash

mkdir digest

# digest mem
cp -r bench_mem digest/mem

cd digest/mem
  $root/digest/python/digest_one_signature.sh "mem"
  $root/digest/python/digest_many_signatures.sh "mem"

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

  $root/digest/python/digest_one_signature.sh "cpu"
  $root/digest/python/digest_many_signatures.sh "cpu"


  ## cleaning temp files
  ls | grep -Ev "^(sign|verify)" | xargs rm

cd ../../
