#!/bin/sh
# function library for coloring book
function tohex {
    if [ $# -ne 1 ]; then
        echo "Error! Invalid arguments for tohex()";
        exit 1;
    fi;
    hexpat='^0x[0-9a-f]*$'
    decpat='^[0-9]*$'
    if [[ $1 =~ $hexpat ]]; then
        echo $1;
    elif [[ $1 =~ $decpat ]]; then
        res=$(echo "obase=16;$1" | bc)
        echo "0x$res"
    else
        echo "Error! Invalid input for tohex()"
        exit 2
    fi;
}