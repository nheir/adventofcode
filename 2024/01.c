#include <stdio.h>

#define MAX_ID 100000

int main(void) {
    int left[MAX_ID] = {0};
    int right[MAX_ID] = {0};

    int l,r;
    int count = 0;
    while (scanf("%d%d", &l, &r) == 2) {
        left[l]++;
        right[r]++;
        count++;
    }

    int i = 0;
    int j = 0;

    int res2 = 0;
    for (int i = 0; i < MAX_ID; i++) {
        res2 += left[i] * i * right[i];
    }

    int res1 = 0;
    while (count > 0) {
        if (left[i] == 0) {
            i++;
        } else if (right[j] == 0) {
            j++;
        } else {
            res1 += i > j ? i - j : j - i;
            left[i]--;
            right[j]--;
            count--;
        }
    }
    printf("%d\n", res1);
    printf("%d\n", res2);
    return 0;
}