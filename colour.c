#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "color.h"
#include "dict.h"

const int args_per_descr = 4;

int main(int argc, char **argv)
{
    --argc;
    ++argv;
    // parse argv into dictionary
    // TODO: dictionary to let fields pass line boundary
    while(argc >= args_per_descr)
    {
        line_coloring_descr_t *cursor =
            (line_coloring_descr_t*)malloc(sizeof(line_coloring_descr_t));
        off_t off = strtol(*argv, NULL, 0);
        --argc;
        ++argv;

        size_t len = strtol(*argv, NULL, 0);
        --argc;
        ++argv;

        uint16_t fg = strtol(*argv, NULL, 0);
        --argc;
        ++argv;

        uint16_t bg = strtol(*argv, NULL, 0);
        --argc;
        ++argv;

        cursor->bg = bg;
        cursor->fg = fg;

        cursor->offset = off % 16;
        while(cursor->offset + len > 16)
        {
            cursor->length = 16 - cursor->offset;
            install((off / 16) << 4, cursor);
            off = ((off / 16) << 4) + 0x10;
            len -= cursor->length;
            cursor =
                (line_coloring_descr_t*)malloc(sizeof(line_coloring_descr_t));
            cursor->offset = off % 16;
            cursor->bg = bg;
            cursor->fg = fg;
        }
        if(len)
        {
            cursor->length = len;
            install((off / 16) << 4, cursor);
        }

    }

    // foreach line in stdin apply from dict
    char *this_line = NULL, *next_line = NULL, *old_line;
    ssize_t ret = 0;
    size_t bytes;
    getline(&this_line, &bytes, stdin);
    while(getline(&next_line, &bytes, stdin) != -1)
    {
        off_t this_line_off = strtol(this_line, NULL, 16);
        struct nlist *nlist = lookup(this_line_off);
        while(nlist && *this_line != '*')
        {
            // fill dscr to color the line
            if(nlist->key == this_line_off)
            {
                line_coloring_descr_t *descr = nlist->value;
                old_line = this_line;
                this_line = apply_to_line(this_line, descr);
                if(this_line != old_line)
                {
                    free(old_line);
                }
            }
            nlist = nlist->next;
        }
        printf("%s", this_line);
        strcpy(this_line, next_line);
    }
    printf("%s", this_line);
    return 0;
}