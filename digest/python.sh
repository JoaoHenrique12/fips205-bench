#!/bin/bash

#TODO: remove me
rm -rf digest

mkdir digest

if [[ $? -eq 0 ]]; then
  # digest mem
  cp -r bench_mem digest/mem
  cd digest/mem

  #TODO: remove me
  rm -rf sign_message-one_time.csv verify_message-one_time.csv

  echo "creating files: sign_message-one_time.csv verify_message-one_time.csv"

  touch sign_message-one_time.csv
  touch verify_message-one_time.csv
  echo "input_in_bytes, memory_used_in_bytes" > sign_message-one_time.csv
  echo "input_in_bytes, memory_used_in_bytes" > verify_message-one_time.csv

  one_message_file_list=$(ls | grep "\-1\.csv")

  regex_get_memory_input='^bench-mem-([a-zA-Z0-9_]+)-([0-9]+)([kM])-([0-9]+)\.csv$'

  for file in ${one_message_file_list[@]}
  do
    if [[ "$file" =~ $regex_get_memory_input ]]; then
      number="${BASH_REMATCH[2]}"
      prefix="${BASH_REMATCH[3]}"

      axis_x=0
      if [[ $prefix == 'k' ]]; then
        axis_x=$(($number * 1024))
      elif [[ $prefix == 'M' ]]; then
        axis_x=$(($number * 1024 * 1024))
      else
        echo "error unidentified prefix, valid prefixes are [kM]"
      fi
      axis_y_sign=$(cat $file | grep sign_message | awk '{print $2}')
      axis_y_verify=$(cat $file | grep verify | awk '{print $2}')

      echo "$axis_x , $axis_y_sign" >> sign_message-one_time.csv
      echo "$axis_x , $axis_y_verify" >> verify_message-one_time.csv

    else
      echo "error retrieving amount of memory input from file; file=$file, regex=$regex_get_memory_input"
    fi
  done
  
  many_times_input_name="lorem-100k"
  echo -n "creating files: sign_message-many_times.csv verify_message-many_times.csv;"
  echo " message used to sign, verify : $many_times_input_name"

  #TODO: remove me
  rm -rf sign_message-many_times.csv verify_message-many_times.csv

  touch sign_message-many_times.csv
  touch verify_message-many_times.csv
  echo "input_in_messages_signed, memory_used_in_bytes" > sign_message-one_time.csv
  echo "input_in_messages_verified, memory_used_in_bytes" > verify_message-one_time.csv

  many_message_file_list=$(ls | grep $many_times_input_name | sort -r)

  for file in ${many_message_file_list[@]}
  do
    if [[ "$file" =~ $regex_get_memory_input ]]; then
      axis_x=${BASH_REMATCH[4]}
      axis_y_sign=$(cat $file | grep sign_message | awk '{print $2}')
      axis_y_verify=$(cat $file | grep verify | awk '{print $2}')

      echo "$axis_x , $axis_y_sign" >> sign_message-many_times.csv
      echo "$axis_x , $axis_y_verify" >> verify_message-many_times.csv

    else
      echo "error retrieving amount of memory input from file; file=$file, regex=$regex_get_memory_input"
    fi
  done

  # cleaning temp files
  ls | grep -Ev "^(sign|verify)" | xargs rm

  cd ../../
  # digest cpu
  # ls
  # cp -r bench_cpu digest/cpu
  # cd digest/cpu
  # for digest_file in $(ls)
  # do
  #   echo "$digest_file"
  # done
  # cd ../../
fi
