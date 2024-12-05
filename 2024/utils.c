
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "utils.h"

struct str read_input() {
    struct str str = {.data = malloc(BUFSIZ), BUFSIZ, 0};
    unsigned char buf[BUFSIZ];
    size_t len;
    while ((len = fread(buf, 1, BUFSIZ, stdin)) > 0) {
        if (len + str.len >= str.capacity) {
            str.capacity *= 2;
            unsigned char *ptr = realloc(str.data, str.capacity);
            if (ptr == NULL) {
                perror("not enough memory...");
                free(str.data);
                exit(EXIT_FAILURE);
            }
            str.data = ptr;
        }
        memcpy(str.data + str.len, buf, len);
        str.len += len;
    }
    return str;
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

long sv_read_int(struct sv sv) {
    long ret = 0;
    for (size_t i = 0; i < sv.len && '0' <= sv.data[i] && sv.data[i] <= '9'; i++)
        ret = ret * 10 + (sv.data[i] - '0');
    return ret;
}