#include <stddef.h>
#include <regex.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

#include "color.h"

int isescape(int c);
int ishex(int c);
size_t skipcolor(char* buf);

const int OFFSET_SIZE = 8;
const uint8_t OFFSET_MASK = 0xf0, LENGTH_MASK = 0x0f;

int apply_to_line(char* line, coloring_descr_t* descr)
{
    /*
     * 000001c0  [38;5;0m[48;5;3m01 00 [0m[38;5;15m[48;5;4mee [0m[38;5;0m[48;5;5mff ff ff [0m[38;5;0m[48;5;6m01 00  00 00 [0m[38;5;0m[48;5;7m2e 60 38 3a [0m[38;5;0m[48;5;2m00 [0m[38;5;0m[48;5;3m00[0m  |[38;5;0m[48;5;3m..[0m[38;5;15m[48;5;4m.[0m[38;5;0m[48;5;5m...[0m[38;5;0m[48;5;6m....[0m[38;5;0m[48;5;7m.`8:[0m[38;5;0m[48;5;2m.[0m[38;5;0m[48;5;3m.[0m|
     * 000001a0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
     */
    char *cursor = line + OFFSET_SIZE;
    int8_t line_off = 0;
    uint8_t end_off = offset(descr) + length(descr);
    printf("%.*s", OFFSET_SIZE, line);
    while(*cursor != '\0')
    {
        if(isescape(*cursor))
        {
            size_t esc_size = skipcolor(cursor);
            printf("%.*s", esc_size, cursor);
            cursor += esc_size;
            continue;
        }
        if(end_off == line_off)
        {
            printf("\e[0m");
        }
        if(line_off == offset(descr))
        {
            printf("\e[48;5;%dm\e[38;5;%dm", descr->bg, descr->fg);
        }
        if(isspace(*cursor))
        {
            printf(" ");
            ++cursor;
            continue;
        }
        if(ishex(*cursor) && ishex(*(cursor + 1)))
        {
            printf("%c%c", *cursor, *(cursor + 1));
            ++line_off;
            cursor += 2;
            continue;
        }
        if(line_off == 16)
        {
            printf("|");
            ++cursor;
            for(line_off = 0; line_off > -16; line_off--)
            {
                while(isescape(*cursor))
                {
                    size_t esc_size = skipcolor(cursor);
                    printf("%.*s", esc_size, cursor);
                    cursor += esc_size;
                }
                if(end_off == -line_off)
                {
                    printf("\e[0m");
                }
                if(-line_off == offset(descr))
                {
                    printf("\e[48;5;%dm\e[38;5;%dm", descr->bg, descr->fg);
                }
                printf("%c", *cursor);
                ++cursor;
            }
            while(isescape(*cursor))
            {
                size_t esc_size = skipcolor(cursor);
                printf("%.*s", esc_size, cursor);
                cursor += esc_size;
            }
            printf("|\n");
            return 1;
        }
        ++cursor;
    }
    return 0;
}

inline int isescape(int c)
{
    if(c == '\e')
        return 1;
    else
        return 0;
}

int ishex(int c)
{
    if((c >= '0' && c <= '9') || (c >= 'a' && c <= 'f') ||
        (c >= 'A' && c <= 'F'))
        return 1;
    else
        return 0;
}

size_t skipcolor(char* buf)
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
    }
    if(error = regexec(&regex, buf, 2, match, 0))
    {
        fprintf(stderr, "regexec error %d\n",error);
        regfree(&regex);
        return 1;
    }
    if(match[1].rm_so != -1)
    {
        return match[1].rm_so;
    }
    regfree(&regex);
    return 1;
}

inline uint8_t length(coloring_descr_t* descr)
{
    return descr->offlen & LENGTH_MASK;
}

inline uint8_t offset(coloring_descr_t* descr)
{
    return descr->offlen >> 4;
}
