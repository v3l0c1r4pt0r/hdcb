#!/bin/sh
# apply color to part of hexdump output
# Usage: hexdump -C file | apply-color color start-byte [length=4]
# where color is number 0-15, start-byte and length could be decimal or hex
if [ $# -lt 2 ]; then
    echo "Error! Too few arguments";
    exit 1;
fi;
color=$1;
sbyte=$2;
length=4;
if [ $# -ge 3 ]; then
    length=$3;
fi;
echo "color $length bytes starting on $sbyte-th byte to color number $color";
exit 0;
