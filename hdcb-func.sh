#!/bin/sh
# function library for hdcb main script

function color {
    if [ $# -ne 3 ]; then
        echo "Error! Invalid arguments for color()";
        exit 1;
    fi;

    color=$1
    offset=$2
    length=$3

    hd="$(echo "$hd" | ./apply-color.sh $(echo "$color" | sed 's/:/ /') $offset $length)";
}
