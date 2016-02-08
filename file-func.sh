#!/bin/sh
# library of input file manipulation functions

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

    if [ $length -gt 8 ]; then
        echo "Unsupported length"
        return;
    fi;

    hexval=$(dd if=$binfile bs=1 skip=$offset count=$length 2>/dev/null | xxd -ps)
    lehextodec $hexval $length;
    eval $shellvar=$lehextodec;
}

function value_be {
    echo "TODO: implement ${FUNCNAME[0]}"
}
