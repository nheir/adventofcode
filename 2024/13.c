#include <stdio.h>

int solve1(int ax, int ay, int bx, int by, int px, int py) {
    for (int i = 0; i <= 400; i++) {
        for (int j = 0; j <= i; j += 3) {
            if (ax * j / 3 + bx * (i - j) == px && ay * j / 3 + by * (i - j) == py)
                return i;
        }
    }
    return 0;
}

struct couple {
    long u, v;
};

struct couple bezout(struct couple a) {
    struct couple b = {.u = 1, .v = 0};
    struct couple c = {.u = 0, .v = 1};
    while (a.v) {
        long q = a.u / a.v;
        long rs = a.u;
        a.u = a.v;
        a.v = rs - q * a.u;

        struct couple d = b;
        b = c;
        c.u = d.u - q * c.u;
        c.v = d.v - q * c.v;
    }
    return b;
}

long solve2(long ax, long ay, long bx, long by, long px, long py) {
    // ax * qx.u + bx * qx.v = gcd(ax,bx) = dx
    struct couple qx = bezout((struct couple){.u = ax, .v = bx});
    long gcd_x = ax * qx.u + bx * qx.v;

    if (px % gcd_x != 0)
        return 0;

    long u = px / gcd_x * qx.u;
    long v = px / gcd_x * qx.v;

    struct couple d = {.u = bx / gcd_x, .v = -ax / gcd_x};

    long delta = d.u * ay + d.v * by;
    if ((u * ay + v * by - py) % delta != 0)
        return 0;

    long q = (py - (u * ay + v * by)) / delta;

    u += q * d.u;
    v += q * d.v;

    if (u >= 0 && v >= 0)
        return u * 3 + v;

    return 0;
}

int main(void) {
    int ax, ay, bx, by, px, py;
    unsigned long count1 = 0;
    unsigned long count2 = 0;
    while (scanf("Button A: X+%d, Y+%d\n"
                 "Button B: X+%d, Y+%d\n"
                 "Prize: X=%d, Y=%d\n",
                 &ax, &ay, &bx, &by, &px, &py) == 6) {
        count1 += solve1(ax, ay, bx, by, px, py);
        count2 += solve2(ax, ay, bx, by, px + 10000000000000L, py + 10000000000000L);
    }
    printf("%lu\n", count1);
    printf("%lu\n", count2);
    return 0;
}