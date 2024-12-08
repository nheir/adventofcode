#include "utils.h"
#include <stdio.h>

struct xy {
    int x, y;
};

struct xy add(struct xy a, struct xy b) {
    return (struct xy){.x = a.x + b.x, .y = a.y + b.y};
}

struct xy sub(struct xy a, struct xy b) {
    return (struct xy){.x = a.x - b.x, .y = a.y - b.y};
}

int inbounds(struct xy p, int w, int h) {
    return 0 <= p.x && p.x < w && 0 <= p.y && p.y < h;
}

struct xy reduce(struct xy a) {
    if (a.x == 0 && a.y == 0)
        return a;
    if (a.x == 0)
        return (struct xy){.y = 1};
    if (a.y == 0)
        return (struct xy){.x = 1};
    int x = a.x > 0 ? a.x : -a.x;
    int y = a.y > 0 ? a.y : -a.y;
    while (y) {
        int r = x % y;
        x = y;
        y = r;
    }
    return (struct xy){.x = a.x / x, .y = a.y / x};
}

struct chain {
    struct xy pos;
    struct chain *next;
};

struct pool {
    struct chain items[50 * 50];
    size_t used;
};

int main(void) {
    struct str content = read_input();
    struct sv sv = {.data = content.data, .len = content.len};
    struct pool pool = {0};
    struct chain *antennas[256] = {0};

    int width = 0;
    int height = 0;
    for (struct pair p = split(sv, '\n'); p.left.len; p = split(p.right, '\n')) {
        width = p.left.len;
        for (int j = 0; j < width; j++) {
            unsigned char c = p.left.data[j];
            if (('0' <= c && c <= '9') || ('a' <= c && c <= 'z') || ('A' <= c && c <= 'Z')) {
                struct chain *ant = &pool.items[pool.used++];
                ant->pos = (struct xy){.x = j, .y = height};
                ant->next = antennas[c];
                antennas[c] = ant;
            }
        }
        height++;
    }

    int count1 = 0;
    int count2 = 0;
    char anti[50][50] = {0};
    for (int i = 0; i < 256; i++) {
        for (struct chain *a = antennas[i]; a; a = a->next) {
            for (struct chain *b = a->next; b; b = b->next) {
                struct xy ab = add(b->pos, sub(b->pos, a->pos));
                if (inbounds(ab, width, height) && !(anti[ab.y][ab.x] & 1)) {
                    anti[ab.y][ab.x]++;
                    count1++;
                }
                struct xy ba = add(a->pos, sub(a->pos, b->pos));
                if (inbounds(ba, width, height) && !(anti[ba.y][ba.x] & 1)) {
                    anti[ba.y][ba.x]++;
                    count1++;
                }
                struct xy n = reduce(sub(b->pos, a->pos));
                for (struct xy start = a->pos; inbounds(start, width, height); start = add(start, n)) {
                    if (!(anti[start.y][start.x] & 2)) {
                        anti[start.y][start.x] |= 2;
                        count2++;
                    }
                }
                for (struct xy start = a->pos; inbounds(start, width, height); start = sub(start, n)) {
                    if (!(anti[start.y][start.x] & 2)) {
                        anti[start.y][start.x] |= 2;
                        count2++;
                    }
                }
            }
        }
    }
    printf("%d\n", count1);
    printf("%d\n", count2);

    str_destroy(&content);

    return 0;
}