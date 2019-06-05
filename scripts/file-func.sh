#!/bin/sh
# library of input file manipulation functions

# get value of var starting at OFFSET having LENGTH and store it in SHELLVAR
# usage: value_le SHELLVAR OFFSET LENGTH
# NOTE: this function gets little-endian value
function value_le {
    if [ $# -lt 3 ]; then
        echo "Error! Invalid arguments for value_le()" >&2;
        return 1;
    fi;
    shellvar=$1
    offset=$2
    length=$3

    if [ $length -gt 8 ]; then
        echo "Unsupported length" >&2;
        return 1;
    fi;

    hexval=$(dd if=$binfile bs=1 skip=$offset count=$length 2>/dev/null | xxd -ps)
    lehextodec $hexval $length;
    errno=$? && [ $errno -ne 0 ] && return $errno;
    eval $shellvar=$lehextodec;
    return 0;
}

function value_be {
    if [ $# -lt 3 ]; then
        echo "Error! Invalid arguments for value_le()" >&2;
        return 1;
    fi;
    shellvar=$1
    offset=$2
    length=$3

    if [ $length -gt 8 ]; then
        echo "Unsupported length" >&2;
        return 1;
    fi;

    hexval=$(dd if=$binfile bs=1 skip=$offset count=$length 2>/dev/null | xxd -ps)
    behextodec $hexval $length;
    errno=$? && [ $errno -ne 0 ] && return $errno;
    eval $shellvar=$lehextodec;
    return 0;
}
