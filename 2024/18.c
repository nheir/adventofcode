#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define SIZE 71

enum {
    UP = 0,
    RIGHT = 1,
    DOWN = 2,
    LEFT = 3,
};

struct item {
    long x, y;
    unsigned cost;
};

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

struct UF {
    int *p;
    size_t n;
};

int parent(struct UF *uf, int x) {
    if (uf->p[x] == x)
        return x;
    uf->p[x] = parent(uf, uf->p[x]);
    return uf->p[x];
}

void merge(struct UF *uf, int x, int y) {
    x = parent(uf, x);
    y = parent(uf, y);
    if (x != y) {
        uf->p[x] = y;
    }
}

void mark(char map[][SIZE], struct UF *uf, int x, int y) {
    map[y][x] = 1;
    // Diagonals are missing but it's ok for the given input...
    if (x == 0)
        merge(uf, x * SIZE + y, SIZE * SIZE + LEFT);
    else if (map[y][x - 1])
        merge(uf, x * SIZE + y, (x - 1) * SIZE + y);
    if (x == SIZE - 1)
        merge(uf, x * SIZE + y, SIZE * SIZE + RIGHT);
    else if (map[y][x + 1])
        merge(uf, x * SIZE + y, (x + 1) * SIZE + y);
    if (y == 0)
        merge(uf, x * SIZE + y, SIZE * SIZE + UP);
    else if (map[y - 1][x])
        merge(uf, x * SIZE + y, x * SIZE + y - 1);
    if (y == SIZE - 1)
        merge(uf, x * SIZE + y, SIZE * SIZE + DOWN);
    else if (map[y + 1][x])
        merge(uf, x * SIZE + y, x * SIZE + y + 1);
}

unsigned bfs(char map[][SIZE]) {
    unsigned cost[SIZE][SIZE] = {0};
    memset(cost, 0xff, sizeof(cost));

    struct circ fifo = {0};

    add(&fifo, (struct item){.y = 0, .x = 0, .cost = 0});

    while (!empty(&fifo)) {
        struct item v = get(&fifo);
        if (map[v.y][v.x])
            continue;
        if (cost[v.y][v.x] <= v.cost)
            continue;
        cost[v.y][v.x] = v.cost;
        if (v.x == SIZE - 1 && v.y == SIZE - 1)
            continue;
        if (v.x > 0)
            add(&fifo, (struct item){.x = v.x - 1, .y = v.y, .cost = v.cost + 1});
        if (v.x < SIZE - 1)
            add(&fifo, (struct item){.x = v.x + 1, .y = v.y, .cost = v.cost + 1});
        if (v.y > 0)
            add(&fifo, (struct item){.x = v.x, .y = v.y - 1, .cost = v.cost + 1});
        if (v.y < SIZE - 1)
            add(&fifo, (struct item){.x = v.x, .y = v.y + 1, .cost = v.cost + 1});
    }

    unsigned ret = cost[SIZE - 1][SIZE - 1];
    free(fifo.data);
    return ret;
}

int main(void) {
    char map[SIZE][SIZE] = {0};

    struct UF uf = {.n = SIZE * SIZE + 4, .p = calloc(SIZE * SIZE + 4, sizeof(*uf.p))};
    for (int i = 0; i < SIZE * SIZE + 4; i++)
        uf.p[i] = i;

    merge(&uf, SIZE * SIZE + LEFT, SIZE * SIZE + DOWN);
    merge(&uf, SIZE * SIZE + UP, SIZE * SIZE + RIGHT);

    int x, y;
    for (int i = 0; i < 1024 && scanf("%d,%d", &x, &y) == 2; i++) {
        mark(map, &uf, x, y);
    }

    unsigned count1 = bfs(map);
    printf("%u\n", count1);

    while (parent(&uf, SIZE * SIZE + DOWN) != parent(&uf, SIZE * SIZE + RIGHT) && scanf("%d,%d", &x, &y) == 2) {
        mark(map, &uf, x, y);
    }
    free(uf.p);

    printf("%d,%d\n", x, y);
    return 0;
}