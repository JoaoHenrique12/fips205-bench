#!/bin/bash

rm digest -rf
mkdir digest

# digest mem
cp -r bench_mem digest/mem

cd digest/mem
  # $root/digest/golang/digest_one_signature.sh "mem"
  # $root/digest/golang/digest_many_signatures.sh "mem"

  ## cleaning temp files
  ls | grep -Ev "^(sign|verify)" | xargs rm
cd ../../

# digest cpu
cp -r bench_cpu digest/cpu
cd digest/cpu

  $root/digest/golang/digest_one_signature.sh "cpu"
  # $root/digest/python/digest_many_signatures.sh "cpu"

  ## cleaning temp files
  ls | grep -Ev "^(sign|verify)" | xargs rm
cd ../../
