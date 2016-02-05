#include <stdint.h>

typedef struct
{
    /**
     * \brief most significant nibble is offset, lsn is lenghth
     */
    uint8_t offlen;
    uint16_t bg, fg;
} coloring_descr_t;

extern const uint8_t OFFSET_MASK, LENGTH_MASK;

extern const int OFFSET_SIZE;

/**
 * \brief get offset from cloring descriptor
 */
uint8_t offset(coloring_descr_t *descr);

/**
 * \brief get length from cloring descriptor
 */
uint8_t length(coloring_descr_t *descr);

/**
 * \brief apply coloring scheme described by descr to line given
 */
int apply_to_line(char *line, coloring_descr_t *descr);
