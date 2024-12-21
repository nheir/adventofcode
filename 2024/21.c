#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BOT_NUM 2

enum Directional {
    GAP,
    UP,
    D_A,
    LEFT,
    DOWN,
    RIGHT,
    D_MAX,
};

enum NumPad {
    N_7,
    N_8,
    N_9,
    N_4,
    N_5,
    N_6,
    N_1,
    N_2,
    N_3,
    N_G,
    N_0,
    N_A,
    N_MAX,
};

const char NumChar[] = {
    [N_7] = '7', [N_8] = '8', [N_9] = '9', [N_4] = '4', [N_5] = '5', [N_6] = '6',
    [N_1] = '1', [N_2] = '2', [N_3] = '3', [N_0] = '0', [N_A] = 'A',
};

struct XY {
    int x, y;
};

struct XY next_coord(struct XY xy, int dir) {
    switch (dir) {
    case UP:
        xy.y--;
        break;
    case DOWN:
        xy.y++;
        break;
    case LEFT:
        xy.x--;
        break;
    case RIGHT:
        xy.x++;
        break;
    }
    return xy;
}

struct item {
    struct XY bot[BOT_NUM + 1];
    int step;
    unsigned cost;
};

int next(struct item *it, enum Directional d, char input[4]) {
    int i;
    it->cost++;
    for (i = 0; i < BOT_NUM && d == D_A; i++) {
        d = it->bot[i].x + it->bot[i].y * 3;
    }
    if (d == D_A) {
        int v = it->bot[BOT_NUM].x + it->bot[BOT_NUM].y * 3;
        if (NumChar[v] != input[it->step])
            return 0;
        it->step++;
        return 1;
    }
    if (d == GAP)
        return 0;
    it->bot[i] = next_coord(it->bot[i], d);
    if (it->bot[i].x < 0 || it->bot[i].x >= 3 || it->bot[i].y < 0)
        return 0;
    if (i == BOT_NUM && it->bot[i].y >= 4)
        return 0;
    if (i < BOT_NUM && it->bot[i].y >= 2)
        return 0;
    if (i == BOT_NUM && it->bot[BOT_NUM].x + it->bot[BOT_NUM].y * 3 == N_G)
        return 0;
    if (i < BOT_NUM && it->bot[i].x + it->bot[i].y * 3 == GAP)
        return 0;
    return 1;
}

struct circ {
    struct item *data;
    size_t capacity;
    size_t start;
    size_t len;
};

void add(struct circ *c, struct item v) {
    if (c->len >= c->capacity) {
        size_t old_capacity = c->capacity;
        if (c->capacity)
            c->capacity *= 2;
        else
            c->capacity = 256;
        void *ptr = realloc(c->data, c->capacity * sizeof(*c->data));
        if (ptr == NULL) {
            perror("not enough memory...");
            free(c->data);
            exit(EXIT_FAILURE);
        }
        c->data = ptr;
        if (c->start + c->len > old_capacity) {
            memcpy(c->data + old_capacity, c->data, sizeof(struct item) * (c->start + c->len - old_capacity));
        }
    }
    size_t pos = c->start + c->len;
    if (pos >= c->capacity)
        pos -= c->capacity;
    c->data[pos] = v;
    c->len++;
}

struct item get(struct circ *c) {
    struct item v = c->data[c->start++];
    if (c->start >= c->capacity)
        c->start = 0;
    c->len--;
    return v;
}

int empty(struct circ *c) {
    return c->len == 0;
}

size_t key(struct item v) {
    size_t k = 0;
    for (int i = 0; i < BOT_NUM; i++) {
        k = k * 6 + v.bot[i].x + v.bot[i].y * 3;
    }
    k = k * 12 + v.bot[BOT_NUM].x + v.bot[BOT_NUM].y * 3;
    k = k * 4 + v.step;
    return k;
}

unsigned bfs(char input[4]) {
    size_t s = 4 * 12;
    for (int i = 0; i < BOT_NUM; i++)
        s *= 6;
    char *visited = calloc(s, 1);
    struct circ fifo = {0};

    unsigned ret = 0;

    struct item start = {0};
    for (int i = 0; i < BOT_NUM; i++)
        start.bot[i] = (struct XY){.x = 2, .y = 0};
    start.bot[BOT_NUM] = (struct XY){.x = 2, .y = 3};

    add(&fifo, start);

    while (!empty(&fifo)) {
        struct item v = get(&fifo);
        if (v.step == 4) {
            ret = v.cost;
            break;
        }
        if (visited[key(v)])
            continue;
        visited[key(v)] = 1;
        for (int i = 0; i < 5; i++) {
            struct item tmp = v;
            if (next(&tmp, (int[5]){UP, DOWN, LEFT, RIGHT, D_A}[i], input)) {
                add(&fifo, tmp);
            }
        }
    }

    free(fifo.data);
    free(visited);
    return ret;
}

int main(void) {
    char input[5][6];
    for (int i = 0; i < 5; i++) {
        fgets(input[i], 6, stdin);
        input[i][4] = 0;
    }

    unsigned count1 = 0;
    for (int i = 0; i < 5; i++) {
        count1 += bfs(input[i]) * strtol(input[i], NULL, 10);
    }

    printf("%u\n", count1);

    return 0;
}