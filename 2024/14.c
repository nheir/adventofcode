#include <stdio.h>
#include <stdlib.h>

struct XY {
    long x, y;
};

int main(int argc, char *argv[]) {
    struct XY p, v;
    struct XY dim = {.x = 101, .y = 103};
    long step = 100;
    if (argc == 4) {
        dim.x = strtol(argv[1], NULL, 10);
        dim.y = strtol(argv[2], NULL, 10);
        step = strtol(argv[3], NULL, 10);
    }
    struct XY center = {
        .x = dim.x / 2,
        .y = dim.y / 2,
    };
    long count[4] = {0};
    while (scanf(" p=%ld,%ld v=%ld,%ld", &p.x, &p.y, &v.x, &v.y) == 4) {
        p.x += v.x * step;
        p.y += v.y * step;
        p.x = p.x % dim.x;
        if (p.x < 0)
            p.x += dim.x;
        p.y = p.y % dim.y;
        if (p.y < 0)
            p.y += dim.y;
        if (p.x != center.x && p.y != center.y)
        count[(p.x > center.x) + (p.y > center.y)*2]++;
    }
    long count1 = count[0] * count[1] * count[2] * count[3];
    printf("%ld\n", count1);
    return 0;
}