#!/bin/sh
# apply color to part of hexdump output
# Usage: hexdump -C file | apply-color fg-color bg-color start-byte [length=4]
# where colors are number 1-255, start-byte and length could be decimal or hex
if [ $# -lt 2 ]; then
    echo "Error! Too few arguments";
    exit 1;
fi;

# set variables
fgcolor=$1;
bgcolor=$2;
sbyte=$3;
length=4;
bgcmd="\e[48;5;@@@m"
fgcmd="\e[38;5;@@@m"
offcmd="\033[0m"
if [ $# -ge 4 ]; then
    length=$4;
fi;

# source all necessary scripts
source ./func.sh

# convert inputs to hexadecimal form
length=$(tohex $length);
sbyte=$(tohex $sbyte);

echo "color $length bytes starting on $sbyte-th byte to color number $bgcolor";
linestart=$(getlinecaption $sbyte);
lspattern="^$linestart\s\s.*$"
clr=${fgcmd//@@@/$fgcolor}${bgcmd//@@@/$bgcolor}
# echo -e "\e[38;5;1m$clr chuj $offcmd"
while read line; do
    if [[ $line =~ $lspattern ]]; then
        echo -e "$clr$line$offcmd";
    else
        echo -e "$line";
    fi;
done;
