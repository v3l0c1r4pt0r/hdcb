#include <stdio.h>

#include "color.h"

int main(int argc, char **argv)
{
    // parse argv into dictionary
    // foreach line in stdin apply from dict
    char *line = NULL;
    ssize_t ret = 0;
    size_t bytes;
    while((ret = getline(&line, &bytes, stdin)) != -1)
    {
        coloring_descr_t descr = {
            .offlen = (2 << 4) | 5,
            .fg = 0,
            .bg = 9
        };
        apply_to_line(line, &descr);
//         printf("%s\n", line);
    }
    return 0;
}