#include <string.h>
#include <stdlib.h>

#include "dict.h"

#define HASHSIZE 128
static struct nlist *hashtab[HASHSIZE]; /* pointer table */

/* hash: form hash value for string s */
unsigned hash(off_t key)
{
    unsigned hashval;
//     for (hashval = 0; *s != '\0'; s++)
//       hashval = *s + 31 * hashval;
    hashval = key;
    return hashval % HASHSIZE;
}

/* lookup: look for s in hashtab */
struct nlist *lookup(off_t key)
{
    struct nlist *np;
    for (np = hashtab[hash(key)]; np != NULL; np = np->next)
        if (key == np->key)
          return np; /* found */
    return NULL; /* not found */
}

/* install: put (name, defn) in hashtab */
struct nlist *install(off_t key, void* value)
{
    // FIXME: should allow inserting more than one element with same key
    struct nlist *np;
    unsigned hashval;
    if ((np = lookup(key)) == NULL) { /* not found */
        np = (struct nlist *) malloc(sizeof(*np));
        if (np == NULL/* || (np->name = name) == NULL*/)
          return NULL;
        np->key = key;
        np->value = value;
        hashval = hash(key);
        np->next = hashtab[hashval];
        hashtab[hashval] = np;
    } else /* already there */
        free((void *) np->value); /*free previous defn */
    if ((np->value = value) == NULL)
       return NULL;
    return np;
}
