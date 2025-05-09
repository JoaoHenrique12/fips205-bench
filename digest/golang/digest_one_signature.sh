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


echo "creating files: sign_message-one_time.csv verify_message-one_time.csv"

touch sign_message-one_time.csv
touch verify_message-one_time.csv
echo "input_bytes, $outputLabel" > sign_message-one_time.csv
echo "input_bytes, $outputLabel" > verify_message-one_time.csv

one_message_file_list=$(ls | grep "\-1\.prof")

regex_get_memory_or_cpu_input='^bench-(mem|cpu)-([a-zA-Z0-9_]+)-([0-9]+)([kM])-([0-9]+)\.prof$'

for file in ${one_message_file_list[@]}
do
  if [[ "$file" =~ $regex_get_memory_or_cpu_input ]]; then
    number="${BASH_REMATCH[3]}"
    prefix="${BASH_REMATCH[4]}"

    axis_x=0
    if [[ $prefix == 'k' ]]; then
      axis_x=$(($number * 1024))
    elif [[ $prefix == 'M' ]]; then
      axis_x=$(($number * 1024 * 1024))
    else
      echo "error unidentified prefix, valid prefixes are [kM]"
    fi

    axis_y_sign="axys_y_sign"
    axis_y_verify="axys_y_verify"

    line=$(go tool pprof -top $file | grep "Showing nodes accounting for")
    regex_get_memory_output='([0-9]+\.[0-9]+)([kM])B'
    if [[ "$line" =~ $regex_get_memory_output ]]; then
      number="${BASH_REMATCH[1]}"
      prefix="${BASH_REMATCH[2]}"
      axis_y=0
      if [[ $prefix == 'k' ]]; then
        axis_y=$(echo "$number * 1024" | bc)
      elif [[ $prefix == 'M' ]]; then
        axis_y=$(echo "$number * 1024 * 1024" | bc)
      else
        echo "error unidentified prefix, valid prefixes are [kM]"
      fi
    fi

    echo "$axis_x , $axis_y" >> sign_message-one_time.csv
    echo "$axis_x , $axis_y" >> verify_message-one_time.csv

  else
    echo "error retrieving amount of memory input from file; file=$file, regex=$regex_get_memory_or_cpu_input"
  fi
done
