#include "utils.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct da {
    struct sv *data;
    size_t capacity;
    size_t len;
};

int startswith(struct sv sv, struct sv pref) {
    return sv.len >= pref.len && memcmp(sv.data, pref.data, pref.len) == 0;
}

void add(struct da *da, struct sv sv) {
    if (da->len >= da->capacity) {
        if (da->capacity)
            da->capacity *= 2;
        else
            da->capacity = 256;
        void *ptr = realloc(da->data, da->capacity * sizeof(*da->data));
        if (ptr == NULL) {
            perror("not enough memory...");
            free(da->data);
            exit(EXIT_FAILURE);
        }
        da->data = ptr;
    }
    da->data[da->len++] = sv;
}

int main(void) {
    struct str content = read_input();
    struct sv sv = {.data = content.data, .len = content.len};

    struct pair p = split(sv, '\n');
    struct sv pattern_line = p.left;
    struct da da = {0};
    for (struct pair p = split(pattern_line, ' '); p.left.len; p = split(p.right, ' ')) {
        add(&da, split(p.left, ',').left);
    }

    p = split(p.right, '\n');
    struct sv designs = p.right;
    int count1 = 0;
    long count2 = 0;
    long *ptr = NULL;
    for (struct pair p = split(designs, '\n'); p.left.len; p = split(p.right, '\n')) {
        struct sv design = p.left;
        ptr = realloc(ptr, sizeof(*ptr) * (design.len + 1));
        memset(ptr, 0, sizeof(*ptr) * (design.len + 1));
        ptr[0] = 1;
        for (size_t i = 0; i < design.len; i++) {
            if (!ptr[i])
                continue;
            struct sv sub = {.data = design.data + i, .len = design.len - i};
            for (size_t j = 0; j < da.len; j++) {
                if (startswith(sub, da.data[j])) {
                    ptr[i + da.data[j].len] += ptr[i];
                }
            }
        }
        if (ptr[design.len])
            count1++;
        count2 += ptr[design.len];
    }
    free(ptr);
    free(da.data);
    str_destroy(&content);

    printf("%d\n", count1);
    printf("%ld\n", count2);

    return 0;
}