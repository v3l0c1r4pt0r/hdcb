#!/bin/sh
# function library for hdcb main script

source ./num-func.sh

# initialize environment
function init {
    cursor=0
    clriterator=0
    clrstream=""
}

function squeeze {
    hd=$(hexdump -C $binfile)
}

# pick next default color pair
function pick {
    pickedcolor="${clrlist[$clriterator]}";
    # FIXME: removing color from array would be safer
    if [ "${clrlist[$clriterator]}t" == "t" ]; then
        echo "Warning! Exhausted all possible automatic color pairs";
        pickedcolor="9:0";
    fi;
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

    clrstream="$clrstream $offset $length ${color//:/ }";
    cursor=$((offset + length));
}

function print {
    echo "$hd" | ./colour $clrstream;
}

# define new variable
# usage: define VARNAME length bg-color fg-color
function define {
# TODO: bg and fg should be optional
    # args
    varname=$1
    len=$2
    bg=$3
    fg=$4

    vars[$varname,1]=$len
    vars[$varname,2]=$bg
    vars[$varname,3]=$fg
}

# use defined variable
# usage: use VARNAME
function use {
    color ${vars[$1,1]} "${vars[$1,2]}:${vars[$1,3]}"
}
