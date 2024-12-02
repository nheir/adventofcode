#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define NB 20

int all(int tab[], int size) {
    for (int i = 0; i < size; i++) {
        if (!tab[i])
            return 0;
        if (tab[i] < -3 || tab[i] > 3)
            return 0;
        if (tab[i] * tab[0] < 0)
            return 0;
    }
    return 1;
}

int all_but_one(int tab[], int size) {
    if (all(tab + 1, size - 1))
        return 1;
    if (all(tab, size - 1))
        return 1;
    for (int i = 0; i < size-1; i++) {
        int tmp[NB] = {0};
        for (int j = 0; j <= i; j++) {
            tmp[j] = tab[j];
        }
        for (int j = i; j < size - 1; j++) {
            tmp[j] += tab[j + 1];
        }
        if (all(tmp, size-1)) return 1;
    }
    return 0;
}

int main(void) {
    char buf[BUFSIZ];
    int count1 = 0;
    int count2 = 0;
    while (fgets(buf, BUFSIZ, stdin)) {
        int vals[NB];
        char *start = strtok(buf, " ");
        int size = 0;
        for (size = 0; start; start = strtok(NULL, " "), size++) {
            vals[size] = strtol(start, NULL, 10);
        }
        for (int i = 0; i < size - 1; i++)
            vals[i] = vals[i + 1] - vals[i];

        if (all(vals, size - 1)) {
            count1++;
            count2++;
        } else if (all_but_one(vals, size-1)) {
            count2++;
        }
    }
    printf("%d\n", count1);
    printf("%d\n", count2);
    return 0;
}