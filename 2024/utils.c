
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "utils.h"

struct str read_input() {
    DA_NEW(str, unsigned char);
    unsigned char buf[BUFSIZ];
    size_t len;
    while ((len = fread(buf, 1, BUFSIZ, stdin)) > 0) {
        DA_EXTEND(str, unsigned char, buf, len);
    }
    return (struct str){.data = str.data, .len = str.len, .capacity = str.capacity};
}

struct sv sv_read_input() {
    DA_NEW(str, unsigned char);
    unsigned char buf[BUFSIZ];
    size_t len;
    while ((len = fread(buf, 1, BUFSIZ, stdin)) > 0) {
        DA_EXTEND(str, unsigned char, buf, len);
    }
    return (struct sv){.data = str.data, .len = str.len};
}

void str_destroy(struct str *str) {
    if (str->data) {
        free(str->data);
        str->data = NULL;
        str->capacity = 0;
        str->len = 0;
    }
}
struct pair split(struct sv sv, char byte) {
    for (size_t i = 0; i < sv.len; i++) {
        if (sv.data[i] == byte) {
            return (struct pair){
                .left = {.data = sv.data, .len = i},
                .right = {.data = sv.data + i + 1, .len = sv.len - i - 1},
            };
        }
    }
    return (struct pair){sv, {0}};
}

struct pair sv_split_byte(struct sv sv, char byte) {
    return split(sv, byte);
}

struct pair sv_split_once(struct sv sv, struct sv sep) {
    for (size_t i = 0; i < sv.len; i++) {
        if (sv_startswith((struct sv){.data = sv.data + i, .len = sv.len - i}, sep)) {
            return (struct pair){
                .left = {.data = sv.data, .len = i},
                .right = {.data = sv.data + i + sep.len, .len = sv.len - i - sep.len},
            };
        }
    }
    return (struct pair){sv, {0}};
}

long sv_read_int(struct sv sv) {
    long ret = 0;
    for (size_t i = 0; i < sv.len && '0' <= sv.data[i] && sv.data[i] <= '9'; i++)
        ret = ret * 10 + (sv.data[i] - '0');
    return ret;
}

int sv_equal(struct sv a, struct sv b) {
    return a.len == b.len && memcmp(a.data, b.data, b.len) == 0;
}

int sv_startswith(struct sv sv, struct sv pref) {
    return sv.len >= pref.len && memcmp(sv.data, pref.data, pref.len) == 0;
}

struct sv *sv_split_array(struct sv sv, struct sv sep, size_t *n) {
    DA_NEW(da, struct sv);
    for (struct pair p = sv_split_once(sv, sep); p.left.data; p = sv_split_once(p.right, sep)) {
        DA_APPEND(da, struct sv, p.left);
    }
    *n = da.len;
    return da.data;
}