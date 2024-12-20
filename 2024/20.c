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

struct item {
    long x, y;
    int depth;
    unsigned cost;
};

struct cc {
    int count, cost;
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

unsigned bfs(int s_x, int s_y, char map[][SIZE], unsigned cost[SIZE][SIZE]) {
    memset(cost, 0xff, sizeof(unsigned[SIZE][SIZE]));

    struct circ fifo = {0};

    add(&fifo, (struct item){.y = s_y, .x = s_x, .cost = 0});

    while (!empty(&fifo)) {
        struct item v = get(&fifo);
        if (map[v.y][v.x] == '#')
            continue;
        if (cost[v.y][v.x] <= v.cost)
            continue;
        cost[v.y][v.x] = v.cost;
        if (v.x == SIZE - 1 && v.y == SIZE - 1)
            break;
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

unsigned best_around(int x, int y, unsigned cost[SIZE][SIZE]) {
    unsigned best = cost[y - 1][x];
    if (best > cost[y + 1][x])
        best = cost[y + 1][x];
    if (best > cost[y][x - 1])
        best = cost[y][x - 1];
    if (best > cost[y][x + 1])
        best = cost[y][x + 1];
    return best;
}

int main(void) {
    char buf[BUFSIZ];
    char map[SIZE][SIZE] = {0};
    int size = 0;
    while (fgets(buf, BUFSIZ, stdin) && buf[0] == '#') {
        memcpy(map[size++], buf, strlen(buf) - 1);
    }

    int s_x, s_y, e_x, e_y;
    for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
            if (map[j][i] == 'E') {
                e_x = i;
                e_y = j;
            }
            if (map[j][i] == 'S') {
                s_x = i;
                s_y = j;
            }
        }
    }

    unsigned cost_start[SIZE][SIZE];
    bfs(s_x, s_y, map, cost_start);
    unsigned cost_exit[SIZE][SIZE];
    bfs(e_x, e_y, map, cost_exit);

    unsigned base_cost = cost_start[e_y][e_x];
    unsigned count1 = 0;

    printf("Best path with %u steps\n", base_cost);

    for (int i = 1; i < size - 1; i++) {
        for (int j = 1; j < size - 1; j++) {
            if (map[j][i] == '#') {
                unsigned best_start = best_around(i, j, cost_start);
                unsigned best_exit = best_around(i, j, cost_exit);
                if (best_start < base_cost && best_exit < base_cost && best_start + 2 + best_exit < base_cost)
                    printf("Save %d at (%d,%d)\n", base_cost - (best_start + 2 + best_exit), i, j);
                if (best_start < base_cost && best_exit < base_cost && best_start + 2 + best_exit + 100 <= base_cost)
                    count1++;
            }
        }
    }
    printf("%d\n", count1);

    unsigned count2 = 0;
    for (int x = 1; x < size - 1; x++) {
        for (int y = 1; y < size - 1; y++) {
            if (map[y][x] == '#')
                continue;
            for (int dx = -20; dx <= 20; dx++) {
                for (int dy = -20; dy <= 20; dy++) {
                    unsigned steps = (dx < 0 ? -dx : dx) + (dy < 0 ? -dy : dy);
                    if (steps > 20)
                        continue;
                    if (x + dx < 0 || x + dx >= size || y + dy < 0 || y + dy >= size)
                        continue;
                    if (map[y + dy][x + dx] == '#')
                        continue;

                    if (cost_start[y][x] + steps + cost_exit[y + dy][x + dx] < base_cost) {
                        unsigned saved = base_cost - (cost_start[y][x] + steps + cost_exit[y + dy][x + dx]);
                        if (saved >= 100) count2++;
                    }
                }
            }
        }
    }
    printf("%d\n", count2);

    return 0;
}