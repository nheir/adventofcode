#include <stdio.h>
#include <stdlib.h>

struct XY {
    long x, y;
};

struct robot {
    struct XY p, v;
};

struct da {
    struct robot *data;
    size_t capacity;
    size_t len;
};

void add(struct da *da, struct robot r) {
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
    da->data[da->len++] = r;
}

int main(int argc, char *argv[]) {
    struct da da = {0};
    struct XY dim = {.x = 101, .y = 103};
    long step = 100;
    if (argc == 4) {
        dim.x = strtol(argv[1], NULL, 10);
        dim.y = strtol(argv[2], NULL, 10);
        step = strtol(argv[3], NULL, 10);
    }
    struct robot r;
    while (scanf(" p=%ld,%ld v=%ld,%ld", &r.p.x, &r.p.y, &r.v.x, &r.v.y) == 4) {
        add(&da, r);
    }

    // part 1
    struct XY center = {
        .x = dim.x / 2,
        .y = dim.y / 2,
    };
    long count[4] = {0};
    for (size_t i = 0; i < da.len; i++) {
        struct robot r = da.data[i];
        struct XY p = {.x = r.p.x + r.v.x * step, .y = r.p.y + r.v.y * step};
        p.x = p.x % dim.x;
        if (p.x < 0)
            p.x += dim.x;
        p.y = p.y % dim.y;
        if (p.y < 0)
            p.y += dim.y;
        if (p.x != center.x && p.y != center.y)
            count[(p.x > center.x) + (p.y > center.y) * 2]++;
    }
    long count1 = count[0] * count[1] * count[2] * count[3];
    printf("%ld\n", count1);

    if (argc > 1) {
        free(da.data);
        return 0;
    }

    // part 2
    int stat = 0;
    int sstat = -1;
    for (size_t s = 0; s < 101 * 103; s++) {
        long count[4] = {0};
        int img[101][103] = {0};
        for (size_t i = 0; i < da.len; i++) {
            struct robot r = da.data[i];
            struct XY p = {.x = r.p.x + r.v.x * s, .y = r.p.y + r.v.y * s};
            p.x = p.x % dim.x;
            if (p.x < 0)
                p.x += dim.x;
            p.y = p.y % dim.y;
            if (p.y < 0)
                p.y += dim.y;
            if (p.x != center.x && p.y != center.y)
                count[(p.x > center.x) + (p.y > center.y) * 2]++;
            img[p.x][p.y] = 1;
        }
        int ml = 0;
        for (int j = 0; j < 103; j++) {
            int m = 0;
            for (int i = 0; i < 101; i++) {
                m+=img[i][j];
            }
            if (ml < m) ml = m;
        }
        for (int i = 0; i < 101; i++) {
            int m = 0;
            for (int j = 0; j < 103; j++) {
                m+=img[i][j];
            }
            if (ml < m) ml = m;
        }
        if (stat < ml) {
            stat = ml;
            sstat = s;
        }
    }
    printf("%d\n", sstat);

    free(da.data);
    return 0;
}