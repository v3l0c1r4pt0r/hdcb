#include <stddef.h>
#include <regex.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

#include "color.h"

int isescape(int c);
int ishex(int c);
size_t skipcolor(char* buf);

const int OFFSET_SIZE = 10;
const uint8_t OFFSET_MASK = 0xf0, LENGTH_MASK = 0x0f;

char *apply_to_line(char* line, line_coloring_descr_t* descr)
{
    /*
     * 000001c0  [38;5;0m[48;5;3m01 00 [0m[38;5;15m[48;5;4mee [0m[38;5;0m[48;5;5mff ff ff [0m[38;5;0m[48;5;6m01 00  00 00 [0m[38;5;0m[48;5;7m2e 60 38 3a [0m[38;5;0m[48;5;2m00 [0m[38;5;0m[48;5;3m00[0m  |[38;5;0m[48;5;3m..[0m[38;5;15m[48;5;4m.[0m[38;5;0m[48;5;5m...[0m[38;5;0m[48;5;6m....[0m[38;5;0m[48;5;7m.`8:[0m[38;5;0m[48;5;2m.[0m[38;5;0m[48;5;3m.[0m|
     * 000001a0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
     */
    char *new_line = (char*)malloc(0x1000);
    char *cursor = line + OFFSET_SIZE;
    int8_t line_off = 0;
    uint8_t end_off = descr->offset + descr->length;
    sprintf(new_line, "%.*s", OFFSET_SIZE, line);
    while(*cursor != '\0')
    {
        if((isspace(*cursor) || isescape(*cursor)) && descr->length>0 && end_off == line_off)
        {
            sprintf(new_line, "%s\e[0m", new_line);
            end_off = 16;
        }
        if(isescape(*cursor))
        {
            size_t esc_size = skipcolor(cursor);
            sprintf(new_line, "%s%.*s", new_line, esc_size, cursor);
            cursor += esc_size;
            continue;
        }
        if((ishex(*cursor) || isspace(*cursor)) && descr->length>0 && line_off == descr->offset)
        {
            sprintf(new_line, "%s\e[48;5;%dm\e[38;5;%dm", new_line, descr->bg, descr->fg);
        }
        if(isspace(*cursor))
        {
            sprintf(new_line, "%s%c", new_line, *cursor);
            ++cursor;
            continue;
        }
        if(ishex(*cursor) && ishex(*(cursor + 1)))
        {
            sprintf(new_line, "%s%c%c", new_line, *cursor, *(cursor + 1));
            ++line_off;
            cursor += 2;
            continue;
        }
        if(*cursor == '|')
        {
            sprintf(new_line, "%s|", new_line);
            ++cursor;
            end_off = descr->offset + descr->length;
            for(line_off = 0; line_off > -16 && *cursor != '|'; line_off--)
            {
                if(descr->length>0 && end_off == -line_off)
                {
                    sprintf(new_line, "%s\e[0m", new_line);
                }
                if(descr->length>0 && -line_off == descr->offset)
                {
                    sprintf(new_line, "%s\e[48;5;%dm\e[38;5;%dm", new_line, descr->bg,
                        descr->fg);
                }
                while(isescape(*cursor))
                {
                    size_t esc_size = skipcolor(cursor);
                    sprintf(new_line, "%s%.*s", new_line, esc_size, cursor);
                    cursor += esc_size;
                }
                sprintf(new_line, "%s%c", new_line, *cursor);
                ++cursor;
            }
            if(descr->length>0 && end_off == -line_off)
            {
                sprintf(new_line, "%s\e[0m", new_line);
            }
            while(isescape(*cursor))
            {
                size_t esc_size = skipcolor(cursor);
                sprintf(new_line, "%s%.*s", new_line, esc_size, cursor);
                cursor += esc_size;
            }
            sprintf(new_line, "%s|\n", new_line);
            return new_line;
        }
        ++cursor;
    }
    return line;
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

// inline uint8_t length(line_coloring_descr_t* descr)
// {
//     return descr->offlen & LENGTH_MASK;
// }
// 
// inline uint8_t offset(line_coloring_descr_t* descr)
// {
//     return descr->offlen >> 4;
// }
