#include <stdint.h>

typedef struct
{
    /**
     * \brief most significant nibble is offset, lsn is lenghth
     */
    uint8_t offlen;
    uint16_t bg, fg;
} coloring_descr_t;

/**
 * \brief apply coloring scheme described by descr to line given
 */
int apply_to_line(char *line, coloring_descr_t *descr);
