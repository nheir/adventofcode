#ifndef UTILS_H
#define UTILS_H

#include <stddef.h>

struct str {
    unsigned char *data;
    size_t capacity;
    size_t len;
};

struct sv {
    const unsigned char *data;
    size_t len;
};

struct pair {
    struct sv left;
    struct sv right;
};


struct str read_input();
void str_destroy(struct str *str);
struct pair split(struct sv sv, char byte);
long sv_read_int(struct sv sv);

#endif