#ifndef UTILS_H
#define UTILS_H

#include <stddef.h>

#define DA_NEW(name, T)                                                                                                \
    struct {                                                                                                           \
        T *data;                                                                                                       \
        size_t len;                                                                                                    \
        size_t capacity;                                                                                               \
    } name = {0};

#define DA_APPEND(name, T, value)                                                                                      \
    do {                                                                                                               \
        if (name.len >= name.capacity) {                                                                               \
            if (!name.capacity)                                                                                        \
                name.capacity = 256;                                                                                   \
            else                                                                                                       \
                name.capacity *= 2;                                                                                    \
            void *ptr = realloc(name.data, sizeof(T) * name.capacity);                                                 \
            if (ptr == NULL) {                                                                                         \
                perror("not enough memory...");                                                                        \
                free(name.data);                                                                                       \
                exit(EXIT_FAILURE);                                                                                    \
            }                                                                                                          \
            name.data = ptr;                                                                                           \
        }                                                                                                              \
        memcpy(name.data + name.len, &value, sizeof(T));                                                               \
        name.len++;                                                                                                    \
    } while (0);

#define DA_EXTEND(name, T, value, size)                                                                                \
    do {                                                                                                               \
        if (name.len + (size) > name.capacity) {                                                                       \
            if (!name.capacity)                                                                                        \
                name.capacity = (size);                                                                                \
            else                                                                                                       \
                while (name.len + (size) > name.capacity)                                                              \
                    name.capacity *= 2;                                                                                \
            void *ptr = realloc(name.data, sizeof(T) * name.capacity);                                                 \
            if (ptr == NULL) {                                                                                         \
                perror("not enough memory...");                                                                        \
                free(name.data);                                                                                       \
                exit(EXIT_FAILURE);                                                                                    \
            }                                                                                                          \
            name.data = ptr;                                                                                           \
        }                                                                                                              \
        memcpy(name.data + name.len, &value, sizeof(T) * (size));                                                      \
        name.len += (size);                                                                                            \
    } while (0);

#define DA_DESTROY(name)                                                                                               \
    do {                                                                                                               \
        free(name.data);                                                                                               \
        name.data = 0;                                                                                                 \
        name.len = name.capacity = 0;                                                                                  \
    } while (0);

#define LIT2SV(lit) ((struct sv){.data = (unsigned char *)(lit), .len = sizeof(lit) - 1})

struct str {
    unsigned char *data;
    size_t capacity;
    size_t len;
};

struct sv {
    const unsigned char *data;
    size_t len;
};

struct pair {
    struct sv left;
    struct sv right;
};

struct str read_input();
void str_destroy(struct str *str);

struct sv sv_read_input();

long sv_read_int(struct sv sv);
int sv_startswith(struct sv sv, struct sv pref);

struct pair split(struct sv sv, char byte);
struct pair sv_split_byte(struct sv sv, char byte);
struct pair sv_split_once(struct sv sv, struct sv sep);

struct sv *sv_split_array(struct sv sv, struct sv sep, size_t *n);

#endif