#!/bin/sh

if [ $# -ne 2 ]; then
    echo "Error! Invalid arguments for hdcb";
    exit 1;
fi;

source ./hdcb-func.sh

# vars
script=$1;
binfile=$2;

# get hex dump
hd=$(hexdump -Cv $binfile)

cursor=0

source ./$script;
