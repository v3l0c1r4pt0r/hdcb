#!/bin/sh
# function library for coloring book

hexpat='^0x[0-9a-fA-F]*$'
bgcmd="\e[48;5;@@@m"
fgcmd="\e[38;5;@@@m"
offcmd="\033[0m"

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

# convert hex number to bc-compatible format
function hextobc {
    if [ $# -ne 1 ]; then
        echo "Error! Invalid arguments for getlinecaption()";
        exit 1;
    fi;
    input=${1//0x/};
    input=${input^^};
    echo $input;
}

# convert hex to decimal
function hextodec {
    if [ $# -ne 1 ]; then
        echo "Error! Invalid arguments for getlinecaption()";
        exit 1;
    fi;
    comm='ibase=16;@num'
    comm=${comm//@num/$(hextobc $1)};
    echo "$comm" | bc;
}

# get first byte number in line that contains byte given
function getlinecaption {
    if [ $# -ne 1 ]; then
        echo "Error! Invalid arguments for getlinecaption()";
        exit 1;
    fi;
    input=$(hextobc $1);
    comm='obase=16;ibase=16;@@@ / 10 * 10'
    res=$(echo "${comm//@@@/$input}" | bc);
    printf "%08s\n" ${res,,} | sed 's/\s/0/g';
}

# get number of bytes in subsequent lines that need to be colored
# usage: cmdlinestream start length;
function cmdlinestream {
    if [ $# -ne 2 ]; then
        echo "Error! Invalid arguments for cmdlinestream()";
        exit 1;
    fi;
    sbyte=$(hextobc $1);
    lng=$(hextodec $2);
    length=$(hextobc $2);
    end=$(echo "obase=10;ibase=16;$sbyte % 10 + $length" | bc);
    if [ $end -lt 16 ]; then
        echo $lng;
        return;
    fi;
    comm='obase=10;ibase=16;10 - ( @sbyte % 10 )'
    comm=${comm//@sbyte/$sbyte};
    next=$(echo "$comm" | bc);
    let lng-=$next;
    stream=$next;
    for (( i=lng; i>=16; i-=16 ));
    do
        stream=$(echo -ne "$stream:16");
        let lng-=16;
    done;
    stream=$(echo -ne "$stream:$lng");
    echo $stream;
}

# get num of bytes after demanded
function bytesafter {
    if [ $# -ne 2 ]; then
        echo "Error! Invalid arguments for bytesafter()";
        exit 1;
    fi;
    offset=$1;
    length=$2;
    echo "16 - ( $offset + $length )" | bc;
}

# color given number of bytes starting at given offset
# usage: colorbytes line fg bg offset length
function colorbytes {
    if [ $# -ne 5 ]; then
        echo "Error! Invalid arguments for colorbytes()";
        exit 1;
    fi;
    line=$1;
    fgcolor=$2;
    bgcolor=$3;
    offset=$4;
    length=$5;

    clr=${fgcmd//@@@/$fgcolor}${bgcmd//@@@/$bgcolor}
    hexpattern='^([0-9a-f]{8}\s*)((?:(?:\e.*m)?[0-9a-f]{2}\s*?(?:\e.*m)?){@bef})((?:(?:\e.*m)?[0-9a-f]{2}\s*?(?:\e.*m)?){@at})((?:(?:\e.*m)?[0-9a-f]{2}\s*?(?:\e.*m)?){@aft})(\s*\|.*\|)$'
    vispattern='^(.*)(\s*\|(?:(?:\e.*m)?.(?:\e.*m)?){@bef})((?:(?:\e.*m)?.(?:\e.*m)?){@at})((?:(?:\e.*m)?.(?:\e.*m)?){@aft}\|)$'
    after=$(bytesafter $offset $length);

    hexpattern=${hexpattern//@bef/$offset};
    hexpattern=${hexpattern//@at/$length};
    hexpattern=${hexpattern//@aft/$after};

    vispattern=${vispattern//@bef/$offset};
    vispattern=${vispattern//@at/$length};
    vispattern=${vispattern//@aft/$after};

    echo "$line" | perl -pe "s/$hexpattern/\1\2$clr\3$offcmd\4\5/" | \
    perl -pe "s/$vispattern/\1\2$clr\3$offcmd\4/"
}
