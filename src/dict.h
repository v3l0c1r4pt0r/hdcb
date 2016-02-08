#include <stdlib.h>
#include <stdio.h>

struct nlist { /* table entry: */
    struct nlist *next; /* next entry in chain */
    off_t key; /* defined name */
    void* value; /* replacement text */
};

struct nlist *lookup(off_t key);
struct nlist *install(off_t key, void* value);