#!/bin/sh
# function library for hdcb main script

function color {
    if [ $# -lt 2 ]; then
        echo "Error! Invalid arguments for color()";
        exit 1;
    fi;

    color=$1
    length=$2
    offset=$cursor

    if [ $# -ne 2 ]; then
        offset=$3
    fi;

    hd="$(echo "$hd" | ./apply-color.sh $(echo "$color" | sed 's/:/ /') $offset $length)";
    cursor=$(echo "$offset + $length" | bc);
}
