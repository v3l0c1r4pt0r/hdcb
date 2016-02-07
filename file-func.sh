#!/bin/sh
# library of input file manipulation functions

# get n-th byte from hexdump
# usage: getbyte N
function getbyte {
    if [ $# -lt 1 ]; then
        echo "Error! Invalid arguments for getbyte()";
        exit 1;
    fi;
    n=$1
    echo "TODO: implement ${FUNCNAME[0]}"
    getbyte=2;
}

# get value of var starting at OFFSET having LENGTH and store it in SHELLVAR
# usage: value_le SHELLVAR OFFSET LENGTH
# NOTE: this function gets little-endian value
function value_le {
    if [ $# -lt 3 ]; then
        echo "Error! Invalid arguments for value_le()";
        exit 1;
    fi;
    shellvar=$1
    offset=$2
    length=$3

    echo "TODO: implement ${FUNCNAME[0]}"
    getbyte $offset;
    eval $shellvar=$getbyte
}

function value_be {
    echo "TODO: implement ${FUNCNAME[0]}"
}