#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct str {
    unsigned char *data;
    size_t capacity;
    size_t len;
};

struct str read_input() {
    struct str str = {.data = malloc(BUFSIZ), BUFSIZ, 0};
    unsigned char buf[BUFSIZ];
    size_t len;
    while ((len = fread(buf, 1, BUFSIZ, stdin)) > 0) {
        if (len + str.len >= str.capacity) {
            str.capacity *= 2;
            unsigned char *ptr = realloc(str.data, str.capacity);
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
    const unsigned char *data;
    size_t len;
};

struct pair {
    struct sv left;
    struct sv right;
};

struct pair split(struct sv sv, char byte) {
    for (size_t i = 0; i < sv.len; i++) {
        if (sv.data[i] == byte) {
            return (struct pair){
                .left = {.data = sv.data, .len = i},
                .right = {.data = sv.data + i + 1, .len = sv.len - i - 1},
            };
        }
    }
    return (struct pair){sv, {0}};
}

struct trans {
    int next;
    int delta;
} const ttable[][256] = {
    [0]['X'] = {1}, [1]['M'] = {2},    [2]['A'] = {3}, [3]['S'] = {4, 1}, [0]['S'] = {4}, [4]['A'] = {5},
    [5]['M'] = {6}, [6]['X'] = {1, 1}, [1]['X'] = {1}, [2]['X'] = {1},    [3]['X'] = {1}, [4]['X'] = {1},
    [5]['X'] = {1}, [1]['S'] = {4},    [2]['S'] = {4}, [4]['S'] = {4},    [5]['S'] = {4}, [6]['S'] = {4},
};

int count_xmas(struct sv content, size_t start, size_t step) {
    int count = 0;
    int hstate = 0;
    for (size_t i = start; i < content.len; i += step) {
        struct trans t = ttable[hstate][content.data[i]];
        hstate = t.next;
        count += t.delta;
    }
    return count;
}

int is_xmas(struct sv lines[3], int i) {
    if (lines[1].data[i] != 'A')
        return 0;
    if (lines[0].data[i - 1] != 'M' && lines[0].data[i - 1] != 'S')
        return 0;
    if (lines[0].data[i + 1] != 'M' && lines[0].data[i + 1] != 'S')
        return 0;
    if (lines[2].data[i - 1] != 'M' && lines[2].data[i - 1] != 'S')
        return 0;
    if (lines[2].data[i + 1] != 'M' && lines[2].data[i + 1] != 'S')
        return 0;
    if (lines[0].data[i - 1] == lines[2].data[i + 1])
        return 0;
    if (lines[2].data[i - 1] == lines[0].data[i + 1])
        return 0;
    return 1;
}

int main(void) {
    struct str content = read_input();

    struct sv sv = {.data = content.data, .len = content.len};

    struct pair pair = split(sv, '\n');
    int width = pair.left.len;

    int count = count_xmas(sv, 0, 1);
    for (int i = 0; i < width; i++) {
        count += count_xmas(sv, i, width + 1);
    }
    for (int i = 0; i < width; i++) {
        count += count_xmas(sv, i, width);
    }
    for (int i = 0; i < width + 2; i++) {
        count += count_xmas(sv, i, width + 2);
    }

    struct sv lines[3];
    lines[0] = pair.left;
    pair = split(pair.right, '\n');
    lines[1] = pair.left;
    pair = split(pair.right, '\n');
    lines[2] = pair.left;

    int count2 = 0;
    while (lines[2].len) {
        for (int i = 1; i < width - 1; i++) {
            count2 += is_xmas(lines, i);
        }
        pair = split(pair.right, '\n');
        lines[0] = lines[1];
        lines[1] = lines[2];
        lines[2] = pair.left;
    }

    free(content.data);

    printf("%d\n", count);
    printf("%d\n", count2);
    
    return 0;
}