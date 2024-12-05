#include "utils.h"
#include <stdio.h>

int isvalid(char rules[][100], long line[], int size) {
    for (int i = 0; i < size; i++) {
        for (int j = 0; j < i; j++) {
            if (rules[line[i]][line[j]] <= 0)
                return 0;
        }
    }
    return 1;
}

void sort(char rules[][100], long line[], int size) {
    for (int i = 0; i < size; i++) {
        long v = line[i];
        int j = i - 1;
        while (j >= 0 && rules[v][line[j]] <= 0) {
            line[j + 1] = line[j];
            j--;
        }
        line[j + 1] = v;
    }
}

int main(void) {
    struct str content = read_input();
    struct sv sv = {.data = content.data, .len = content.len};
    char rules[100][100] = {0};

    struct pair p = split(sv, '\n');
    while (p.left.len) {
        struct pair r = split(p.left, '|');
        long a = sv_read_int(r.left);
        long b = sv_read_int(r.right);
        rules[a][b] = -1;
        rules[b][a] = 1;
        p = split(p.right, '\n');
    }

    int res1 = 0;
    int res2 = 0;

    for (p = split(p.right, '\n'); p.left.len; p = split(p.right, '\n')) {
        struct sv line = p.left;
        long vals[100] = {0};
        int size = 0;
        for (struct pair u = split(line, ','); u.left.len; u = split(u.right, ',')) {
            vals[size++] = sv_read_int(u.left);
        }
        if (isvalid(rules, vals, size))
            res1 += vals[size / 2];
        else {
            sort(rules, vals, size);
            res2 += vals[size / 2];
        }
    }

    str_destroy(&content);

    printf("%d\n", res1);
    printf("%d\n", res2);
    return 0;
}