#!/bin/sh
# function library for hdcb main script

# initialize environment
function init {
    cursor=0
    clriterator=0
}

# pick next default color pair
function pick {
    pickedcolor="${clrlist[$clriterator]}";
    # FIXME: removing colro from array would be safer
    let clriterator++;
}

function color {
    if [ $# -lt 1 ]; then
        echo "Error! Invalid arguments for color()";
        exit 1;
    fi;

    length=$1
    offset=$cursor
    if [ $# -ge 2 ]; then
        color=$2;
    else
        pick;
        color=$pickedcolor;
    fi;

    if [ $# -ge 3 ]; then
        offset=$3
    fi;

    hd="$(echo "$hd" | ./apply-color.sh $(echo "$color" | sed 's/:/ /') $offset $length)";
    cursor=$(echo "$offset + $length" | bc);
}

function print {
    echo "$hd";
}
