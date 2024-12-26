#include <stdio.h>
#include <stdlib.h>

#include "utils.h"

struct i5 {
    int p[5];
};

int compat(struct i5 a, struct i5 b) {
    for (int i = 0; i < 5; i++) {
        if (a.p[i] + b.p[i] > 5)
            return 0;
    }
    return 1;
}

int main(void) {
    DA_NEW(locks, struct i5);
    DA_NEW(keys, struct i5);

    char buf[10];
    while (fgets(buf, 10, stdin)) {
        int is_lock = buf[0] == '#';
        struct i5 v = {0};
        for (int i = 0; i < 5; i++) {
            fgets(buf, 10, stdin);
            for (int i = 0; i < 5; i++) {
                v.p[i] += buf[i] == '#';
            }
        }
        fgets(buf, 10, stdin);
        fgets(buf, 10, stdin);
        if (is_lock)
            DA_APPEND(locks, struct i5, v);
        else
            DA_APPEND(keys, struct i5, v);
    }

    int count1 = 0;
    for (int i = 0; i < locks.len; i++) {
        for (int j = 0; j < keys.len; j++) {
            count1 += compat(locks.data[i], keys.data[j]);
        }
    }

    DA_DESTROY(keys);
    DA_DESTROY(locks);

    printf("%d\n", count1);
    return 0;
}