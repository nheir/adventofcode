#include <stdio.h>
#include <stdlib.h>

struct pair {
    long v;
    long occ;
};

struct da {
    struct pair *data;
    size_t capacity;
    size_t len;
};

struct pair *lookup(struct da *da, long v) {
    size_t i = 0;
    size_t j = da->len;
    while (i < j) {
        size_t mid = i + (j - i) / 2;
        if (da->data[mid].v == v) {
            return &da->data[mid];
        } else if (da->data[mid].v < v) {
            i = mid + 1;
        } else {
            j = mid;
        }
    }
    return NULL;
}

void add(struct da *da, long v, long occ) {
    struct pair *p = lookup(da, v);
    if (p) {
        p->occ += occ;
        return;
    }
    if (da->len >= da->capacity) {
        if (da->capacity)
            da->capacity *= 2;
        else
            da->capacity = 256;
        struct pair *ptr = realloc(da->data, da->capacity * sizeof(*da->data));
        if (ptr == NULL) {
            perror("not enough memory...");
            free(da->data);
            exit(EXIT_FAILURE);
        }
        da->data = ptr;
    }
    size_t pos = da->len;
    while (pos > 0 && da->data[pos - 1].v > v) {
        da->data[pos] = da->data[pos - 1];
        pos--;
    }
    da->data[pos] = (struct pair){.v = v, .occ = occ};
    da->len += 1;
}

void step(struct pair p, struct da *dest) {
    if (p.v == 0) {
        add(dest, 1, p.occ);
    } else {
        long m1 = 10, m2 = 10;
        long c = 1;
        while (p.v >= m1) {
            m1 *= 10;
            c++;
            if (c & 1)
                m2 *= 10;
        }
        if ((c & 1)) {
            add(dest, p.v * 2024, p.occ);
        } else {
            add(dest, p.v / m2, p.occ);
            add(dest, p.v % m2, p.occ);
        }
    }
}

void dostep(struct da *da, struct da *s) {
    for (size_t j = 0; j < da->len; j++) {
        step(da->data[j], s);
    }
    struct da tmp = *da;
    *da = *s;
    *s = tmp;
    s->len = 0;
}

int main(void) {
    struct da da = {0};
    int n;
    while (scanf("%d", &n) == 1) {
        add(&da, n, 1);
    }

    struct da tmp = {0};
    for (int i = 0; i < 25; i++) {
        dostep(&da, &tmp);
    }

    long count1 = 0;
    for (size_t i = 0; i < da.len; i++) {
        count1 += da.data[i].occ;
    }

    for (int i = 25; i < 75; i++) {
        dostep(&da, &tmp);
    }

    long count2 = 0;
    for (size_t i = 0; i < da.len; i++) {
        count2 += da.data[i].occ;
    }
    free(da.data);
    free(tmp.data);

    printf("%ld\n", count1);
    printf("%ld\n", count2);

    return 0;
}