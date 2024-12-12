#include "utils.h"
#include <stdio.h>
#include <stdlib.h>

enum {
    UP = 1,
    RIGHT = 2,
    DOWN = 4,
    LEFT = 8,
};

struct UF {
    int *p;
    int *count;
    int *borders;
    int *corners;
    size_t n;
};

void local_merge(struct UF *uf, int p, int s) {
    uf->count[p] += uf->count[s];
    uf->count[s] = 0;
    uf->borders[p] += uf->borders[s];
    uf->borders[s] = 0;
    uf->corners[p] += uf->corners[s];
    uf->corners[s] = 0;
}

int parent(struct UF *uf, int x) {
    if (uf->p[x] == x)
        return x;
    uf->p[x] = parent(uf, uf->p[x]);
    local_merge(uf, uf->p[x], x);
    return uf->p[x];
}

void merge(struct UF *uf, int x, int y) {
    x = parent(uf, x);
    y = parent(uf, y);
    if (x != y) {
        uf->p[x] = y;
        local_merge(uf, y, x);
    }
}

int main(void) {
    struct str content = read_input();
    struct sv sv = {.data = content.data, .len = content.len};

    int width = 0;
    int height = 0;

    for (struct pair p = split(sv, '\n'); p.left.len; p = split(p.right, '\n')) {
        width = p.left.len;
        height++;
    }

    struct UF uf = {
        .p = calloc(height * width, sizeof(int)),
        .count = calloc(height * width, sizeof(int)),
        .borders = calloc(height * width, sizeof(int)),
        .corners = calloc(height * width, sizeof(int)),
        .n = height * width,
    };
    for (size_t i = 0; i < uf.n; i++) {
        uf.p[i] = i;
        uf.count[i] = 1;
    }

    for (int j = 0; j < width; j++) {
        uf.borders[j]++;
        uf.borders[(height - 1) * width + j]++;
    }
    uf.corners[0]++;
    uf.corners[width - 1]++;
    uf.corners[height * width - height]++;
    uf.corners[height * width - 1]++;

    int i = 0;
    for (struct pair p = split(sv, '\n'); p.left.len; p = split(p.right, '\n')) {
        uf.borders[parent(&uf, i * width)] += 1;
        uf.borders[parent(&uf, i * width + width - 1)] += 1;
        for (int j = 0; j < width - 1; j++) {
            if (p.left.data[j] == p.left.data[j + 1])
                merge(&uf, i * width + j, i * width + j + 1);
            else {
                uf.borders[parent(&uf, i * width + j)] += 1;
                uf.borders[parent(&uf, i * width + j + 1)] += 1;
                if (i == 0 || i == height - 1) {
                    uf.corners[parent(&uf, i * width + j)] += 1;
                    uf.corners[parent(&uf, i * width + j + 1)] += 1;
                }
            }
        }
        if (p.right.len) {
            for (int j = 0; j < width; j++) {
                if (p.left.data[j] == p.right.data[j])
                    merge(&uf, i * width + j, i * width + j + width);
                else {
                    uf.borders[parent(&uf, i * width + j)] += 1;
                    uf.borders[parent(&uf, i * width + j + width)] += 1;
                    if (j == 0 || j == width - 1) {
                        uf.corners[parent(&uf, i * width + j)] += 1;
                        uf.corners[parent(&uf, i * width + j + width)] += 1;
                    }
                }
            }

            for (int j = 0; j < width - 1; j++) {
                int test = 0;
                if (p.left.data[j] != p.right.data[j])
                    test |= LEFT;
                if (p.left.data[j + 1] != p.right.data[j + 1])
                    test |= RIGHT;
                if (p.left.data[j] != p.left.data[j + 1])
                    test |= UP;
                if (p.right.data[j] != p.right.data[j + 1])
                    test |= DOWN;
                if ((test & (LEFT | UP)) == (LEFT | UP) || test == (RIGHT | DOWN))
                    uf.corners[parent(&uf, i * width + j)] += 1;
                if ((test & (RIGHT | UP)) == (RIGHT | UP)|| test == (LEFT | DOWN))
                    uf.corners[parent(&uf, i * width + j + 1)] += 1;
                if ((test & (LEFT | DOWN)) == (LEFT | DOWN)|| test == (RIGHT | UP))
                    uf.corners[parent(&uf, (i + 1) * width + j)] += 1;
                if ((test & (RIGHT | DOWN)) == (RIGHT | DOWN)|| test == (LEFT | UP))
                    uf.corners[parent(&uf, (i + 1) * width + j + 1)] += 1;
            }
        }
        i++;
    }

    int count1 = 0;
    int count2 = 0;

    for (size_t i = 0; i < uf.n; i++) {
        count1 += uf.count[i] * uf.borders[i];
        count2 += uf.count[i] * uf.corners[i];
    }

    printf("%d\n", count1);
    printf("%d\n", count2);

    free(uf.p);
    free(uf.count);
    free(uf.borders);
    free(uf.corners);
    str_destroy(&content);

    return 0;
}