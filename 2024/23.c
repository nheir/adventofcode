#include <limits.h>
#include <stdio.h>

#define NEXT(v) (((v) & 31) == 25 ? (v) + 7 : (v) + 1)

void naive_prim(char graph[][32 * 26], int set[], int size, int best[], int *max) {
    if (*max < size) {
        *max = size;
        for (int i = 0; i < size; i++) {
            best[i] = set[i];
        }
    }
    for (int i = NEXT(set[size - 1]); i < 32 * 26; i = NEXT(i)) {
        char connected = 1;
        for (int j = 0; j < size; j++) {
            if (!graph[set[j]][i]) {
                connected = 0;
                break;
            }
        }
        if (connected) {
            set[size] = i;
            naive_prim(graph, set, size + 1, best, max);
        }
    }
}

int naive(char graph[][26 * 32], int best[]) {
    int max = 0;
    int set[26 * 32];
    for (int i = 0; i < 32 * 26; i = NEXT(i)) {
        set[0] = i;
        naive_prim(graph, set, 1, best, &max);
    }
    return max;
}

int main(void) {
    char graph[32 * 26][32 * 26] = {0};

    char buf[4];
    while (scanf(" %c%c-%c%c", buf, buf + 1, buf + 2, buf + 3) == 4) {
        int u = (buf[0] - 'a') << 5 | (buf[1] - 'a');
        int v = (buf[2] - 'a') << 5 | (buf[3] - 'a');
        graph[u][v] = graph[v][u] = 1;
    }
    long count1 = 0;
    for (int i = 0; i < 32 * 26; i = NEXT(i)) {
        for (int j = NEXT(i); j < 32 * 26; j = NEXT(j)) {
            if (!graph[i][j])
                continue;
            for (int k = NEXT(j); k < 32 * 26; k = NEXT(k)) {
                if (graph[i][k] && graph[j][k]) {
                    if ((i >> 5) == 19 || (j >> 5) == 19 || (k >> 5) == 19)
                        count1++;
                }
            }
        }
    }
    printf("%ld\n", count1);

    int ret2[26 * 32];
    int size = naive(graph, ret2);
    for (int i = 0; i < size; i++) {
        printf("%c%c%c", (ret2[i] >> 5) + 'a', (ret2[i] & 31) + 'a', i == size - 1 ? '\n' : ',');
    }

    return 0;
}