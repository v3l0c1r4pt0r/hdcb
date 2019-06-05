#!/bin/sh
# library of number manipulation functions

# convert hex number to bc-compatible format
function hextobc {
    if [ $# -ne 1 ]; then
        echo "Error! Invalid arguments for hextobc()" >&2;
        return 1;
    fi;
    input=${1//0x/};
    input=${input^^};
    hextobc=$input;
    return 0;
}

# convert hex to decimal
function hextodec {
    if [ $# -ne 1 ]; then
        echo "Error! Invalid arguments for hextodec()" >&2;
        return 1;
    fi;
    comm='ibase=16;@num'
    hextobc $1;
    comm=${comm//@num/$hextobc};
    hextodec=$(echo "$comm" | bc);
    return 0;
}

# get position of cursor in tty
function ttycursor {
    if [ ! -t 1 ]; then
        # not an interactive shell, bye!
        ROW=0;
        COLUMN=0;
        return 1;
    fi;
    echo -en "\E[6n"
    read -sdR CURPOS
    CURPOS=${CURPOS#*[}
    COLUMN=$(echo $CURPOS | sed 's/^.*;\(.*\)$/\1/')
    ROW=$(echo $CURPOS | sed 's/^\(.*\);.*$/\1/')
    return 0;
}

# convert little-endian VALUE of LENGTH to decimal
# usage: lehextodec VALUE LENGTH
function lehextodec {
    if [ $# -lt 2 ]; then
        echo "Error! Invalid arguments for ${FUNCNAME[0]}()" >&2;
        return 1;
    fi;
    value=$1
    length=$2

    lehextodec=0
    power=1

    for (( i=0; i<${#value}; i+=2 )); do
        hextodec ${value:$i:2};
        let lehextodec+=($hextodec * $power);
        let power*=256;
    done;
    return 0;
}

# convert big-endian VALUE of LENGTH to decimal
# usage: behextodec VALUE LENGTH
function behextodec {
    if [ $# -lt 2 ]; then
        echo "Error! Invalid arguments for ${FUNCNAME[0]}()";
        exit 1;
    fi;
    value=$1
    length=$2

    lehextodec=0
    power=1

    for (( i=${#value}-2; i>=0; i-=2 )); do
        hextodec ${value:$i:2};
        let lehextodec+=($hextodec * $power);
        let power*=256;
    done;
    return 0;
}
