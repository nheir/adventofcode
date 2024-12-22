#include <stdio.h>

unsigned key(int changes[4]) {
    int k = (changes[0] + 9);
    k = k * 20 + changes[1] + 9;
    k = k * 20 + changes[2] + 9;
    k = k * 20 + changes[3] + 9;
    return k;
}

unsigned long next(unsigned long n) {
    n = (n << 6) ^ n;
    n &= 0xffffffUL;
    n = (n >> 5) ^ n;
    n &= 0xffffffUL;
    n = (n << 11) ^ n;
    n &= 0xffffffUL;
    return n;
}

int main(void) {
    unsigned long bananas[20 * 20 * 20 * 20] = {0};
    long ret = 0;
    unsigned long n;
    while (scanf("%lu", &n) == 1) {
        unsigned long current[20 * 20 * 20 * 20] = {0};
        int p = n % 10;
        int changes[4] = {0, 0, 0, 0};
        for (int i = 0; i < 2000; i++) {
            n = next(n);
            changes[0] = changes[1];
            changes[1] = changes[2];
            changes[2] = changes[3];
            changes[3] = n % 10 - p;
            p = n % 10;
            if (i >= 3 && !current[key(changes)]) {
                current[key(changes)] = 1;
                bananas[key(changes)] += p;
            }
        }
        ret += n;
    }
    printf("%lu\n", ret);

    unsigned long count2 = 0;
    for (int i = 0; i < 20 * 20 * 20 * 20; i++) {
        if (count2 < bananas[i]) {
            count2 = bananas[i];
        }
    }
    printf("%lu\n", count2);
    return 0;
}