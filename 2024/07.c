#include "utils.h"
#include <stdio.h>

int isvalid(long obj, long start, long vals[], int size) {
    if (obj < start)
        return 0;
    if (size == 0)
        return obj == start;
    return isvalid(obj, start * vals[0], vals + 1, size - 1) || isvalid(obj, start + vals[0], vals + 1, size - 1);
}

long concat(long a, long b) {
    long s = 10;
    while (s <= b)
        s *= 10;
    return a * s + b;
}

int isvalid2(long obj, long start, long vals[], int size) {
    if (obj < start)
        return 0;
    if (size == 0)
        return obj == start;
    return isvalid2(obj, start * vals[0], vals + 1, size - 1) ||
           isvalid2(obj, concat(start, vals[0]), vals + 1, size - 1) ||
           isvalid2(obj, start + vals[0], vals + 1, size - 1);
}

int main(void) {
    struct str content = read_input();
    struct sv sv = {.data = content.data, .len = content.len};

    long res1 = 0;
    long res2 = 0;

    for (struct pair p = split(sv, '\n'); p.left.len; p = split(p.right, '\n')) {
        struct pair line = split(p.left, ' ');
        long v = sv_read_int(line.left);
        long vals[100] = {0};
        int size = 0;
        for (struct pair u = split(line.right, ' '); u.left.len; u = split(u.right, ' ')) {
            vals[size++] = sv_read_int(u.left);
        }

        if (isvalid(v, vals[0], vals + 1, size - 1))
            res1 += v;
        if (isvalid2(v, vals[0], vals + 1, size - 1))
            res2 += v;
    }

    str_destroy(&content);

    printf("%ld\n", res1);
    printf("%ld\n", res2);
    return 0;
}