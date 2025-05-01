#!/bin/bash

if [ "$#" -ne 1 ]; then
  echo "Error: This script expects exactly one argument."
  echo "-> outputLabel = ['cpu', 'mem'] "
  exit 1
fi

outputLabel="memory_used_bytes"

if [[ $1 == "cpu" ]]; then
  outputLabel="seconds_took"
fi


#TODO: remove me
rm -rf sign_message-many_times.csv verify_message-many_times.csv

echo "creating files: sign_message-many_times.csv verify_message-many_times.csv"

touch sign_message-many_times.csv
touch verify_message-many_times.csv
echo "input_messages_signed, $outputLabel" > sign_message-many_times.csv
echo "input_messages_verified, $outputLabel" > verify_message-many_times.csv

many_times_input_name="lorem-100k"
many_message_file_list=$(ls | grep $many_times_input_name | sort -r)
regex_get_n_messages_input='^bench-(mem|cpu)-([a-zA-Z0-9_]+)-([0-9]+)([kM])-([0-9]+)\.csv$'

for file in ${many_message_file_list[@]}
do
  if [[ "$file" =~ $regex_get_n_messages_input ]]; then
    axis_x=${BASH_REMATCH[5]}
    axis_y_sign=$(cat $file | grep sign_message | awk '{print $2}')
    axis_y_verify=$(cat $file | grep verify | awk '{print $2}')

    echo "$axis_x , $axis_y_sign" >> sign_message-many_times.csv
    echo "$axis_x , $axis_y_verify" >> verify_message-many_times.csv

  else
    echo "error retrieving amount of memory input from file; file=$file, regex=$regex_get_memory_input"
  fi
done
