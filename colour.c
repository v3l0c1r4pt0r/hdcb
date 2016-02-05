#include <stdio.h>
#include <stdlib.h>

#include "color.h"

const int args_per_descr = 4;

int main(int argc, char **argv)
{
    --argc;
    ++argv;
    // parse argv into dictionary
    coloring_descr_t descr[argc/args_per_descr], *cursor = descr;
    while(argc >= args_per_descr)
    {
        cursor->offset = strtol(*argv, NULL, 16);
        --argc;
        ++argv;

        cursor->length = strtol(*argv, NULL, 16);
        --argc;
        ++argv;

        cursor->bg = strtol(*argv, NULL, 16);
        --argc;
        ++argv;

        cursor->fg = strtol(*argv, NULL, 16);
        --argc;
        ++argv;

        cursor++;
    }

    // foreach line in stdin apply from dict
    cursor = descr;
    char *this_line = NULL, *next_line = NULL;
    ssize_t ret = 0;
    size_t bytes;
    getline(&this_line, &bytes, stdin);
    while(getline(&next_line, &bytes, stdin) != -1)
    {
        line_coloring_descr_t dscr = {0};
        off_t this_line_off = strtol(this_line, NULL, 16);
        if(this_line_off == ((cursor->offset / 16) << 4))
        {
            // fill dscr to color the line
            dscr.offlen = cursor->offset % 16 << 4;
            dscr.bg = cursor->bg;
            dscr.fg = cursor->fg;
            if(offset(&dscr) + cursor->length > 16)
            {
                dscr.offlen |= (16 - offset(&dscr));
            }
            else
            {
                dscr.offlen |= cursor->length;
            }
            ++cursor;
        }
        apply_to_line(this_line, &dscr);
        this_line = next_line;
    }
    printf("\n", this_line);
    return 0;
}