#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BOT_NUM 25

const char keypad[4][3] = {{'7', '8', '9'}, {'4', '5', '6'}, {'1', '2', '3'}, {' ', '0', 'A'}};
const int poskey[128] = {['7'] = 0, ['8'] = 1, ['9'] = 2, ['4'] = 3,  ['5'] = 4, ['6'] = 5,
                         ['1'] = 6, ['2'] = 7, ['3'] = 8, ['0'] = 10, ['A'] = 11};

const char dirpad[2][3] = {{' ', '^', 'A'}, {'<', 'v', '>'}};

void enumerate_path(long acc, char prev, int gap, int sx, int sy, int ex, int ey, long cost[128][128], long *min) {
    if (sx == ex && sy == ey) {
        acc += cost[prev]['A'];
        if (*min > acc)
            *min = acc;
        return;
    }
    if (sx+sy*3 == gap) return;
    if (sx < ex) enumerate_path(acc + cost[prev]['>'], '>', gap, sx+1, sy, ex, ey, cost, min);
    if (sx > ex) enumerate_path(acc + cost[prev]['<'], '<', gap, sx-1, sy, ex, ey, cost, min);
    if (sy > ey) enumerate_path(acc + cost[prev]['^'], '^', gap, sx, sy-1, ex, ey, cost, min);
    if (sy < ey) enumerate_path(acc + cost[prev]['v'], 'v', gap, sx, sy+1, ex, ey, cost, min);
}

long min_path(int gap, int sx, int sy, int ex, int ey, long cost[128][128]) {
    long min = LONG_MAX;
    enumerate_path(0, 'A', gap, sx, sy, ex, ey, cost, &min);
    return min;
}

int main(void) {
    char input[5][6];
    for (int i = 0; i < 5; i++) {
        fgets(input[i], 6, stdin);
        input[i][4] = 0;
    }

    long cost[BOT_NUM + 1][128][128];
    memset(cost, 0xff, sizeof(cost));
    for (int i = 0; i < 128; i++) {
        for (int j = 0; j < 128; j++)
            cost[0][i][j] = 1;
        for (int j = 0; j <= BOT_NUM; j++)
            cost[j][i][i] = 1;
    }

    for (int d = 1; d <= 25; d++) {
        for (int i = 1; i < 6; i++) {
            for (int j = 1; j < 6; j++) {
                if (i == j)
                    continue;
                long min = min_path(0, i % 3, i / 3, j % 3, j / 3, cost[d - 1]);
                cost[d][dirpad[i / 3][i % 3]][dirpad[j / 3][j % 3]] = min;
            }
        }
    }
    
    unsigned count1 = 0;
    for (int i = 0; i < 5; i++) {
        int p = poskey['A'];
        long c = 0;
        for (int j = 0; j < 4; j++) {
            int n = poskey[input[i][j]];
            c += min_path(9, p % 3, p / 3, n % 3, n / 3, cost[2]);
            p = n;
        }
        count1 += c * strtol(input[i], NULL, 10);
        printf("%s: %ld\n", input[i], c);
    }
    printf("%u\n", count1);

    long count2 = 0;
    for (int i = 0; i < 5; i++) {
        int p = poskey['A'];
        long c = 0;
        for (int j = 0; j < 4; j++) {
            int n = poskey[input[i][j]];
            c += min_path(9, p % 3, p / 3, n % 3, n / 3, cost[BOT_NUM]);
            p = n;
        }
        count2 += c * strtol(input[i], NULL, 10);
        printf("%s: %ld\n", input[i], c);
    }
    printf("%ld\n", count2);

    return 0;
}