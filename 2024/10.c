#include "utils.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

enum {
    UP = 1,
    RIGHT = 2,
    DOWN = 4,
    LEFT = 8,
};

int main(void) {
    struct str content = read_input();
    struct sv sv = {.data = content.data, .len = content.len};

    int width = 0;
    int height = 0;

    char neigh[42][42] = {0};

    int(*steps)[42][42][42] = calloc(42, sizeof(*steps));
    for (struct pair p = split(sv, '\n'); p.left.len; p = split(p.right, '\n')) {
        width = p.left.len;
        for (int j = 0; j < width - 1; j++) {
            if (p.left.data[j] - p.left.data[j + 1] == 1)
                neigh[height][j + 1] |= LEFT;
            else if (p.left.data[j + 1] - p.left.data[j] == 1)
                neigh[height][j] |= RIGHT;
        }
        if (p.right.len) {
            for (int j = 0; j < width; j++) {
                if (p.left.data[j] - p.right.data[j] == 1)
                    neigh[height + 1][j] |= UP;
                else if (p.right.data[j] - p.left.data[j] == 1)
                    neigh[height][j] |= DOWN;
            }
        }

        for (int j = 0; j < width; j++) {
            if (p.left.data[j] == '9')
                steps[height][j][height][j] = 1;
        }
        height++;
    }

    int(*step)[42][42][42] = calloc(42, sizeof(*steps));
    for (int _ = 0; _ < 9; _++) {
        memset(step, 0, sizeof(int[42][42][42][42]));
        for (int i = 0; i < height; i++) {
            for (int j = 0; j < width; j++) {
                char n = neigh[i][j];
                for (int k = 0; k < height; k++) {
                    for (int l = 0; l < width; l++) {
                        int r = 0;
                        if (n & UP) {
                            r += steps[i - 1][j][k][l];
                        }
                        if (n & DOWN) {
                            r += steps[i + 1][j][k][l];
                        }
                        if (n & LEFT) {
                            r += steps[i][j - 1][k][l];
                        }
                        if (n & RIGHT) {
                            r += steps[i][j + 1][k][l];
                        }
                        step[i][j][k][l] = r;
                    }
                }
            }
        }
        memcpy(steps, step, sizeof(int[42][42][42][42]));
    }
    free(step);

    int count1 = 0;
    int count2 = 0;

    for (int i = 0; i < height; i++) {
        for (int j = 0; j < width; j++) {
            for (int k = 0; k < height; k++) {
                for (int l = 0; l < width; l++) {
                    count1 += steps[i][j][k][l] > 0;
                    count2 += steps[i][j][k][l];
                }
            }
        }
    }
    free(steps);
    
    printf("%d\n", count1);
    printf("%d\n", count2);

    str_destroy(&content);

    return 0;
}