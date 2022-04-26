#!/bin/bash

job_events=(part-00000-of-00500.csv.gz part-00001-of-00500.csv.gz part-00002-of-00500.csv.gz)

machine_attributes=(part-00000-of-00001.csv.gz)
machine_events=(part-00000-of-00001.csv.gz)

task_constraints=(part-00000-of-00500.csv.gz part-00001-of-00500.csv.gz part-00002-of-00500.csv.gz)

task_events=(part-00000-of-00500.csv.gz part-00001-of-00500.csv.gz part-00002-of-00500.csv.gz)

task_usage=(part-00000-of-00500.csv.gz part-00001-of-00500.csv.gz part-00002-of-00500.csv.gz)

if [ "$1" == "-h" ] || [ "$1" == "/h" ]; then
  echo "Downloads a set of files from a subdirectory in the Google Cluster Data bucket."
  echo "The script automatically resumes stopped downloads."
  echo ""
  echo "Usage: $0 [output dir (default is the current dir)]"
  exit 0
fi

OUTPUT_DIR="."
if [ $# -eq 1 ]; then
  OUTPUT_DIR="$1"
fi

#Downloads a set of files from a subdirectory in the Google Cluster Data bucket.
#The script automatically resumes stopped downloads.
#$1 - Subdirectory of the trace files
#$2 - Array of files to download from the given subdirectory in the Google Cluster Data bucket
function download(){
  #Gets all parameters as an array
  #The first parameter with the dir name will be the first element in the array
  FILE_ARRAY=("$@") 

  mkdir -p "$OUTPUT_DIR/$DIR"
  i=0
  for file in "${FILE_ARRAY[@]}"
  do
    if [ $i -eq 0 ]; then
         DIR="$file"
    else
        output="$OUTPUT_DIR/$DIR/$file"
        url="https://commondatastorage.googleapis.com/clusterdata-2011-2/$DIR/$file"
        echo ""
        echo "Downloading $DIR/$file files to $output"
        if [ -f "$output" ]; then
          curl -L -o "$output" -C - "$url"
        else
          curl -L -o "$output" "$url"
        fi
    fi  
    i=$((i+1))
  done  
}

download "machine_attributes" "${machine_attributes[@]}"
download "machine_events" "${machine_events[@]}"
download "job_events" "${job_events[@]}"
download "task_constraints" "${task_constraints[@]}"
download "task_events" "${task_events[@]}"
download "task_usage" "${task_usage[@]}"