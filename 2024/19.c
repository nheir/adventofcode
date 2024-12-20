#include "utils.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(void) {
    struct str content = read_input();
    struct sv content_view = {.data = content.data, .len = content.len};

    struct pair pline = split(content_view, '\n');
    
    size_t pattern_count;
    struct sv *patterns = sv_split_array(pline.left, LIT2SV(", "), &pattern_count);

    pline = split(pline.right, '\n');
    struct sv designs = pline.right;

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
            for (size_t j = 0; j < pattern_count; j++) {
                if (sv_startswith(sub, patterns[j])) {
                    ptr[i + patterns[j].len] += ptr[i];
                }
            }
        }
        if (ptr[design.len])
            count1++;
        count2 += ptr[design.len];
    }
    free(ptr);
    free(patterns);

    str_destroy(&content);

    printf("%d\n", count1);
    printf("%ld\n", count2);

    return 0;
}