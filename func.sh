#!/bin/sh
# function library for coloring book

hexpat='^0x[0-9a-fA-F]*$'

# convert input number to hexadecimal form
function tohex {
    if [ $# -ne 1 ]; then
        echo "Error! Invalid arguments for tohex()";
        exit 1;
    fi;
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

# get first byte number in line that contains byte given
function getlinecaption {
    if [ $# -ne 1 ]; then
        echo "Error! Invalid arguments for getlinecaption()";
        exit 1;
    fi;
    input=$1
    if [[ $input =~ $hexpat ]]; then
        input=${input//0x/};
    fi;
    input=${input^^};
    comm='obase=16;ibase=16;@@@ / 10 * 10'
    res=$(echo "${comm//@@@/$input}" | bc);
    printf "%08s\n" ${res,,} | sed 's/\s/0/g';
}