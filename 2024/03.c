#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int lazy_part1() {
    int res = 0;
    int a, b;
    int c;
    char p;
    while ((c = scanf("mul(%d,%d%c", &a, &b, &p)) >= 0) {
        switch (c) {
        case 0:
        case 1:
        case 2:
            scanf("%*c");
            break;
        case 3:
            if (p == ')' && a >= 0 && a < 1000 && b >= 0 && b < 1000) {
                res += a * b;
                printf("%d\n", a * b);
            } else if (p == 'm')
                ungetc('m', stdin);
        default:;
        }
    }
    printf("%d\n", res);
    return 0;
}

struct str {
    char *data;
    size_t capacity;
    size_t len;
};

struct str read_input() {
    struct str str = {.data = malloc(BUFSIZ), BUFSIZ, 0};
    char buf[BUFSIZ];
    size_t len;
    while ((len = fread(buf, 1, BUFSIZ, stdin)) > 0) {
        if (len + str.len >= str.capacity) {
            str.capacity *= 2;
            char *ptr = realloc(str.data, str.capacity);
            if (ptr == NULL) {
                perror("not enough memory...");
                free(str.data);
                exit(EXIT_FAILURE);
            }
            str.data = ptr;
        }
        memcpy(str.data + str.len, buf, len);
        str.len += len;
    }
    return str;
}

struct sv {
    const char *data;
    size_t len;
};

int match(struct sv *sv, const char *w, size_t len) {
    if (sv->len >= len && memcmp(sv->data, w, len) == 0) {
        sv->data += len;
        sv->len -= len;
        return 1;
    }
    return 0;
}

enum token {
    DO = 1,
    DONT,
    MUL,
    END,
} get_token(struct sv *str) {
    if (str->len == 0)
        return END;
    if (match(str, "don't()", 7)) {
        return DONT;
    }
    if (match(str, "do()", 4)) {
        return DO;
    }
    if (match(str, "mul(", 4)) {
        return MUL;
    }
    if (isdigit(str->data[0])) {
        char *p;
        long n = strtol(str->data, &p, 10);
        str->len -= p - str->data;
        str->data = p;
        return -n;
    }
    str->data++;
    str->len--;
    return str->data[-1];
}

int main(void) {
    struct str str = read_input();
    struct sv sv = {
        .data = str.data,
        .len = str.len,
    };
    int n;
    int dont = 0;
    int state = 0;
    int res1 = 0;
    int res2 = 0;
    int v;
    while ((n = get_token(&sv)) != END) {
        if (n == DO) {
            dont = 0;
            state = 0;
            continue;
        }
        if (n == DONT) {
            dont = 1;
            state = 0;
            continue;
        }
        if (n == MUL) {
            state = 1;
            continue;
        }
        if (state == 1 && n <= 0 && n > -1000) {
            v = -n;
            state++;
            continue;
        }
        if (state == 2 && n == ',') {
            state++;
            continue;
        }
        if (state == 3 && n <= 0 && n > -1000) {
            v *= -n;
            state++;
            continue;
        }
        if (state == 4 && n == ')') {
            state = 0;
            res1 += v;
            if (!dont)
                res2 += v;
            continue;
        }
        state = 0;
    }
    free(str.data);
    printf("%d\n", res1);
    printf("%d\n", res2);
    return 0;
}