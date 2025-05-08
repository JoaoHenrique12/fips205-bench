#!/bin/bash

mkdir digest

# digest mem
cp -r bench_mem digest/mem

cd digest/mem
  $root/digest/golang/digest_one_signature.sh "mem"
  # $root/digest/golang/digest_many_signatures.sh "mem"
  ls

  ## cleaning temp files
  ls | grep -Ev "^(sign|verify)" | xargs rm
cd ../../

rm digest -rf
