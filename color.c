#include <stddef.h>
#include <regex.h>
#include <stdio.h>
#include <stdlib.h>

#include "color.h"

int isescape(char *buf);
char *skipcolor(char *buf);

int apply_to_line(char* line, coloring_descr_t* descr)
{
    /*
     * 000001c0  [38;5;0m[48;5;3m01 00 [0m[38;5;15m[48;5;4mee [0m[38;5;0m[48;5;5mff ff ff [0m[38;5;0m[48;5;6m01 00  00 00 [0m[38;5;0m[48;5;7m2e 60 38 3a [0m[38;5;0m[48;5;2m00 [0m[38;5;0m[48;5;3m00[0m  |[38;5;0m[48;5;3m..[0m[38;5;15m[48;5;4m.[0m[38;5;0m[48;5;5m...[0m[38;5;0m[48;5;6m....[0m[38;5;0m[48;5;7m.`8:[0m[38;5;0m[48;5;2m.[0m[38;5;0m[48;5;3m.[0m|
     * 000001a0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
     */
    char *cursor = line;
    while(*cursor != '\0')
    {
        if(isescape(cursor))
        {
            cursor = skipcolor(cursor);
        }
        else
        {
            printf("%c", *cursor);
            cursor++;
        }
    }
}

inline int isescape(char* buf)
{
    if(*buf == '\e')
        return 1;
    else
        return 0;
}

char* skipcolor(char* buf)
{
    regex_t regex;
    regmatch_t match[2];
    /*
     * \e[48;5;${i}m     - background
     * \e[38;5;${i}m     - foreground
     * \e[0m             - off
     */
    // regex
    int error;
    if(error = regcomp(&regex, "^\e\\[[^m]*m(.*)$", REG_EXTENDED))
    {
        fprintf(stderr, "regcomp error %d\n",error);
        exit(1);
        return buf;
    }
    if(error = regexec(&regex, buf, 2, match, 0))
    {
        fprintf(stderr, "regexec error %d\n",error);
        regfree(&regex);
        exit(1);
        return buf;
    }
    if(match[1].rm_so != -1)
    {
        buf += match[1].rm_so;
    }
    regfree(&regex);
    return buf;
}
