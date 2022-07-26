#!/usr/bin/env bash
dir=$1
commit=$2
cmd=$3 

function version() {
    echo 1
}

function applicable() {
    echo "true"
}

function run() {
    echo "[{ \"type\": \"Global Info\", \
            \"message\": \"Lift is analyzing commit $commit\", \
            \"file\": \"file.txt\", \
            \"category\": \"Info\", \
            \"details_url\": \"https://example.com/#example\" \
          }]"
}

if [[ "$cmd" = "run" ]] ; then 
    run 
fi 
if [[ "$cmd" = "applicable" ]] ; then 
    applicable 
fi 
if [[ "$cmd" = "version" ]] ; then 
    version 
fi