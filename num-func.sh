#!/bin/sh
# library of number manipulation functions

# convert hex number to bc-compatible format
function hextobc {
    if [ $# -ne 1 ]; then
        echo "Error! Invalid arguments for hextobc()";
        exit 1;
    fi;
    input=${1//0x/};
    input=${input^^};
    hextobc=$input;
}

# convert hex to decimal
function hextodec {
    if [ $# -ne 1 ]; then
        echo "Error! Invalid arguments for hextodec()";
        exit 1;
    fi;
    comm='ibase=16;@num'
    hextobc $1;
    comm=${comm//@num/$hextobc};
    hextodec=$(echo "$comm" | bc);
}

# get position of cursor in tty
function ttycursor {
    echo -en "\E[6n"
    read -sdR CURPOS
    CURPOS=${CURPOS#*[}
    COLUMN=$(echo $CURPOS | sed 's/^.*;\(.*\)$/\1/')
    ROW=$(echo $CURPOS | sed 's/^\(.*\);.*$/\1/')
}