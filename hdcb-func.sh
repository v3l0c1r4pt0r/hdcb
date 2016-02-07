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
# usage: define VARNAME length [bg-color fg-color]
function define {
    if [ $# -lt 2 ]; then
        echo "Error! Invalid arguments for define()";
        exit 1;
    fi;

    # args
    varname=$1
    len=$2
    if [ $# -ge 4 ];then
        bg=$3
        fg=$4
    else
        pick;
        bg=$(echo $pickedcolor | sed 's/^\(.*\):.*$/\1/')
        fg=$(echo $pickedcolor | sed 's/^.*:\(.*\)$/\1/')
    fi;

    vars[$varname,1]=$len
    vars[$varname,2]=$bg
    vars[$varname,3]=$fg
}

# use defined variable
# usage: use VARNAME [dup]
function use {
    if [ $# -lt 1 ]; then
        echo "Error! Invalid arguments for use()";
        exit 1;
    fi;
    len=${vars[$1,1]};
    if [ $# -ge 2 ]; then
        # duplicate variable DUP times
        let len*=$2;
    fi;
    color $len "${vars[$1,2]}:${vars[$1,3]}"
}

function legend {
    varnames=""
    esc="\e[0m"
    for index in ${!vars[*]}
    do
        re='^(.*),.*$'
        while [[ $index =~ $re ]]; do
            index=${BASH_REMATCH[1]}
        done
        varnames="$varnames$index\n"
    done
    echo
    for varname in $(echo -ne "$varnames" | sort | uniq); do
        bg=${vars[$varname,2]}
        fg=${vars[$varname,3]}
        bgcmd="\e[38;5;${bg}m"
        fgcmd="\e[48;5;${fg}m"
        ttycursor;
        if (( $COLUMN + ${#varname} + 2 > 80 )); then
            echo
        fi;
        echo -ne "[$bgcmd$fgcmd$varname$esc] ";
    done;
    echo
}
