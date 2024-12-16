#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define SIZE 150

enum {
    UP = 0,
    RIGHT = 1,
    DOWN = 2,
    LEFT = 3,
};

static struct XY {
    int x, y;
} const delta[] = {
    [UP] = {.x = 0, .y = -1},
    [RIGHT] = {.x = 1, .y = 0},
    [DOWN] = {.x = 0, .y = 1},
    [LEFT] = {.x = -1, .y = 0},
};

struct item {
    long x, y;
    int dir;
    unsigned cost;
};

struct da {
    struct item *data;
    size_t capacity;
    size_t start;
    size_t len;
};

void add(struct da *da, struct item v) {
    if (da->start * 2 > da->len) {
        memcpy(da->data, da->data + da->start, sizeof(struct item) * (da->len - da->start));
        da->len -= da->start;
        da->start = 0;
    }
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
    da->data[da->len++] = v;
}

int empty(struct da *da) {
    return da->start >= da->len;
}

struct item get(struct da *da) {
    return da->data[da->start++];
}

int main(void) {
    char buf[BUFSIZ];
    char map[SIZE][SIZE] = {0};
    int size = 0;
    while (fgets(buf, BUFSIZ, stdin) && buf[0] == '#') {
        memcpy(map[size++], buf, strlen(buf) - 1);
    }

    unsigned cost[SIZE][SIZE][4] = {0};
    memset(cost, 0xff, sizeof(cost));

    struct da fifo = {0};

    add(&fifo, (struct item){.y = size - 2, .x = 1, .dir = RIGHT, .cost = 0});

    while (!empty(&fifo)) {
        struct item v = get(&fifo);
        if (map[v.y][v.x] == '#')
            continue;
        if (cost[v.y][v.x][v.dir] <= v.cost)
            continue;
        cost[v.y][v.x][v.dir] = v.cost;
        if (map[v.y][v.x] == 'E')
            continue;
        add(&fifo,
            (struct item){.x = v.x + delta[v.dir].x, .y = v.y + delta[v.dir].y, .dir = v.dir, .cost = v.cost + 1});
        add(&fifo, (struct item){.x = v.x, .y = v.y, .dir = (v.dir + 1) % 4, .cost = v.cost + 1000});
        add(&fifo, (struct item){.x = v.x, .y = v.y, .dir = (v.dir + 3) % 4, .cost = v.cost + 1000});
    }

    struct item end = {.y = 1, .x = size - 2, .dir = 0, .cost = cost[1][size - 2][0]};
    for (int i = 1; i < 4; i++) {
        if (end.cost > cost[1][size - 2][i]) {
            end.cost = cost[1][size - 2][1];
            end.dir = i;
        }
    }
    unsigned count1 = end.cost;
    printf("%u\n", count1);

    add(&fifo, end);
    while (!empty(&fifo)) {
        struct item v = get(&fifo);
        if (v.cost != cost[v.y][v.x][v.dir])
            continue;
        map[v.y][v.x] = 'O';
        if (v.cost > 0)
            add(&fifo,
                (struct item){.x = v.x - delta[v.dir].x, .y = v.y - delta[v.dir].y, .dir = v.dir, .cost = v.cost - 1});
        if (v.cost >= 1000) {
            add(&fifo, (struct item){.x = v.x, .y = v.y, .dir = (v.dir + 1) % 4, .cost = v.cost - 1000});
            add(&fifo, (struct item){.x = v.x, .y = v.y, .dir = (v.dir + 3) % 4, .cost = v.cost - 1000});
        }
    }
    free(fifo.data);

    unsigned count2 = 0;
    for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
            if (map[i][j] == 'O')
                count2++;
        }
    }

    printf("%u\n", count2);
    return 0;
}