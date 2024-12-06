#include "utils.h"
#include <stdio.h>

struct xy {
    int x, y;
};

enum dir {
    UP,
    RIGHT,
    DOWN,
    LEFT,
    NDIR
};
const struct xy delta[] = {
    [UP] = {.x = -1, .y = 0}, [RIGHT] = {.x = 0, .y = 1}, [DOWN] = {.x = 1, .y = 0}, [LEFT] = {.x = 0, .y = -1}};

struct xy add(struct xy a, struct xy b) {
    return (struct xy){.x = a.x + b.x, .y = a.y + b.y};
}

struct dt {
    int tab[130];
    int size;
};

int path(char map[][130], struct xy start, int width, int height) {
    int res = 0;
    enum dir dir = UP;
    struct xy next = add(start, delta[dir]);
    while (next.x >= 0 && next.y >= 0 && next.x < height && next.y < width) {
        if (map[next.x][next.y] & 1) {
            dir = (dir + 1) % NDIR;
            next = add(start, delta[dir]);
        } else {
            if (map[next.x][next.y] & (1 << (2 + dir))) {
                res = 1;
                break;
            }
            map[next.x][next.y] |= (1 << (2 + dir));
            start = next;
            next = add(next, delta[dir]);
        }
    }

    for (int i = 0; i < height; i++) {
        for (int j = 0; j < width; j++) {
            map[i][j] &= 0x3;
        }
    }
    return res;
}

int main(void) {
    struct str content = read_input();
    struct sv sv = {.data = content.data, .len = content.len};
    char map[130][130] = {0};

    struct xy start;
    int width = 0;
    int height = 0;
    for (struct pair p = split(sv, '\n'); p.left.len; p = split(p.right, '\n')) {
        width = p.left.len;
        for (int j = 0; j < width; j++) {
            if (p.left.data[j] == '#') {
                map[height][j] = 1;
            } else if (p.left.data[j] != '.')
                start = (struct xy){.x = height, .y = j};
        }
        height++;
    }

    map[start.x][start.y] = 2;

    enum dir dir = UP;

    int count = 1;
    struct xy curr = start;
    struct xy next = add(curr, delta[dir]);
    while (next.x >= 0 && next.y >= 0 && next.x < height && next.y < width) {
        if (map[next.x][next.y] & 1) {
            dir = (dir + 1) % NDIR;
            next = add(curr, delta[dir]);
        } else {
            if ((map[next.x][next.y] & 2) == 0)
                count++;
            map[next.x][next.y] |= 2;
            curr = next;
            next = add(next, delta[dir]);
        }
    }
    printf("%d\n", count);

    int count2 = 0;
    map[start.x][start.y] = 0;
    for (int i = 0; i < height; i++) {
        for (int j = 0; j < width; j++) {
            if (map[i][j] & 2) {
                map[i][j] |= 1;
                count2 += path(map, start, width, height);
                map[i][j] &= ~1;
            }
        }
    }
    printf("%d\n", count2);

    str_destroy(&content);

    return 0;
}