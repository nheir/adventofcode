#include "utils.h"
#include <stdio.h>
#include <stdlib.h>

long part1(struct sv sv) {
    int max_id = sv.len / 2;

    int i = 0;
    int j = max_id;

    long count1 = 0;

    int spaces = sv.data[1] - '0';
    int available = sv.data[j * 2] - '0';
    int pos = sv.data[0] - '0';
    while (i < j) {
        if (available > spaces) {
            for (int k = 0; k < spaces; k++) {
                count1 += pos * j;
                pos++;
            }
            available -= spaces;
            i++;
            if (i < j) {
                for (int k = '0'; k < sv.data[i * 2]; k++) {
                    count1 += pos * i;
                    pos++;
                }
            }
            spaces = sv.data[i * 2 + 1] - '0';
        } else {
            for (int k = 0; k < available; k++) {
                count1 += pos * j;
                pos++;
            }
            spaces -= available;
            j--;
            available = sv.data[j * 2] - '0';
        }
    }
    if (available > 0) {
        for (int k = 0; k < available; k++) {
            count1 += pos * j;
            pos++;
        }
    }
    return count1;
}

struct block {
    int id;
    int used;
    int start;
    int len;
    struct block *prev, *next;
};

void remove_block(struct block *b) {
    if (b->prev) b->prev->next = b->next;
    if (b->next) b->next->prev = b->prev;
    b->prev = NULL;
    b->next = NULL;
}

void insert_block(struct block *list,struct block *b) {
    b->prev = list;
    b->next = list->next;
    list->next = b;
    if (b->next) b->next->prev = b;
}

long part2(struct sv sv) {
    struct block *block = calloc(sv.len, sizeof(struct block));
    int pos = 0;
    for (size_t i = 0; i < sv.len; i++) {
        block[i] = (struct block){
            .used = !(i & 1),
            .len = sv.data[i] - '0',
            .start = pos,
            .next = (i < sv.len - 1) ? &block[i + 1] : NULL,
            .prev = (i > 0) ? &block[i - 1] : NULL,
            .id = i / 2,
        };
        pos += block[i].len;
    }

    for (int i = sv.len-1; i >= 0; i--) {
        if (!block[i].used) continue;
        for (int j = 0; j < i; j++) {
            if (block[j].used) continue;
            if (block[j].len < block[i].len) continue;
            block[i].start = block[j].start;
            block[j].len -= block[i].len;
            block[j].start += block[i].len;
            remove_block(&block[i]);
            insert_block(block[j].prev, &block[i]);
            break;
        }
    }

    long count = 0;
    for (struct block *b = block; b; b = b->next) {
        if (b->used) {
            for (int i = 0; i < b->len; i++) {
                count += b->id * (i + b->start);
            }
        }
    }

    free(block);
    return count;
}

int main(void) {
    struct str content = read_input();
    struct sv sv = {.data = content.data, .len = content.len};
    sv = split(sv, '\n').left;

    printf("%ld\n", part1(sv));
    printf("%ld\n", part2(sv));

    str_destroy(&content);

    return 0;
}