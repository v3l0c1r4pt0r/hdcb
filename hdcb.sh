#!/bin/sh

if [ $# -ne 2 ]; then
    echo "Error! Invalid arguments for hdcb";
    exit 1;
fi;

source ./hdcb-func.sh
source ./colors.sh

# vars
script=$1;
binfile=$2;

# get hex dump
hd=$(hexdump -Cv $binfile)

# initialization
declare -A vars
init;

source ./$script;

print;

legend;
