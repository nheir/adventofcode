#include <stdio.h>
enum Op {
    ADV,
    BXL,
    BST,
    JNZ,
    BXC,
    OUT,
    BDV,
    CDV
};

void display_prog(int prog[], size_t size) {
    for (size_t i = 0; i < size; i += 2) {
        enum Op op = prog[i];
        int v = prog[i + 1];
        switch (op) {
        case ADV:
        case BDV:
        case CDV:
            if (v < 4)
                printf("%c = A >> %d;\n", "ABC"[(op == BDV) | ((op == CDV) * 2)], v);
            else
                printf("%c = A >> %c;\n", "ABC"[(op == BDV) | ((op == CDV) * 2)], "ABC"[v & 3]);
            break;
        case BXC:
            printf("B = B ^ C;\n");
            break;
        case BXL:
            printf("B = B ^ %d;\n", v);
            break;
        case BST:
            if (v < 4)
                printf("B = %d & 7;\n", v);
            else
                printf("B = %c & 7;\n", "ABC"[v & 3]);
            break;
        case OUT:
            if (v < 4)
                printf("print %d & 7;\n", v);
            else
                printf("print %c & 7;\n", "ABC"[v & 3]);
            break;
        case JNZ:
            printf("jnz %d;\n", v);
            break;
        }
    }
}

int step(int prog[], size_t size, unsigned long regs[]) {
    int ret = -1;
    for (size_t i = 0; i < size; i += 2) {
        enum Op op = prog[i];
        int v = prog[i + 1];
        switch (op) {
        case ADV:
        case BDV:
        case CDV: {
            int dst = (op == BDV) | ((op == CDV) * 2);
            if (v < 4)
                regs[dst] = regs[0] >> v;
            else
                regs[dst] = regs[0] >> regs[v & 3];
        } break;
        case BXC:
            regs[1] ^= regs[2] & 7;
            break;
        case BXL:
            regs[1] ^= v;
            break;
        case BST:
            if (v < 4)
                regs[1] = v & 7;
            else
                regs[1] = regs[v & 3] & 7;
            break;
        case OUT:
            if (v < 4)
                ret = v & 7;
            else
                ret = regs[v & 3] & 7;
            break;
        case JNZ:
            return ret;
        }
    }
    return -1;
}

unsigned long test(int prog[], size_t size, unsigned long regs[]) {
    for (size_t i = 0; i < size; i++) {
        if (step(prog, size, regs) != prog[i])
            return i;
    }
    return size;
}

int main(void) {
    unsigned long regs[3];
    int prog[20];

    scanf(" Register A: %ld", &regs[0]);
    scanf(" Register B: %ld", &regs[1]);
    scanf(" Register C: %ld", &regs[2]);

    scanf(" Program:");
    size_t size = 0;
    while (scanf("%d", &prog[size]) == 1) {
        scanf(" ,");
        size++;
    }

    while (regs[0]) {
        printf("%d,", step(prog, size, regs));
    }
    printf("\n");

    size_t min = 1UL << (3 * size - 1);
    size_t max = min << 3;
    size_t s = 1;
    for (unsigned long n = min; n < max; n += s) {
        int c = test(prog, size, (unsigned long[3]){n, 0, 0});
        if (c > 2 && s < (1UL << (c - 3) * 3)) {
            s <<= 3;
        }
        if (c == size) {
            printf("%zu\n", n);
            break;
        }
    }

    return 0;
}