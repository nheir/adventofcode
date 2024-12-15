#include <stdio.h>
#include <string.h>

#define SIZE 100

int hole(int x, int y, int dx, int dy, char map[][SIZE]) {
    int s = 1;
    x += dx;
    y += dy;
    while (map[x][y] != '#') {
        if (map[x][y] == '.')
            return s;
        x += dx;
        y += dy;
        s++;
    }
    return 0;
}

void move_line(int y, int dy, int s, char line[]) {
    if (dy > 0)
        memmove(&line[y + 1], &line[y], s);
    else
        memmove(&line[y - s], &line[y - s + 1], s);
    line[y] = '.';
}

int hole2(int x, int y, int dx, char map[][SIZE]) {
    if (map[x + dx][y] == '#')
        return 0;
    if (map[x + dx][y] == '[') {
        return hole2(x + dx, y, dx, map) && hole2(x + dx, y + 1, dx, map);
    }
    if (map[x + dx][y] == ']') {
        return hole2(x + dx, y, dx, map) && hole2(x + dx, y - 1, dx, map);
    }
    return 1;
}
void move2(int x, int y, int dx, char map[][SIZE]) {
    if (map[x + dx][y] == '[') {
        move2(x + dx, y, dx, map);
        move2(x + dx, y + 1, dx, map);
    } else if (map[x + dx][y] == ']') {
        move2(x + dx, y, dx, map);
        move2(x + dx, y - 1, dx, map);
    }
    map[x + dx][y] = map[x][y];
    map[x][y] = '.';
}

int main(void) {
    char buf[BUFSIZ];
    char map[SIZE][SIZE];
    int size = 0;
    while (fgets(buf, BUFSIZ, stdin) && buf[0] == '#') {
        memcpy(map[size++], buf, strlen(buf) - 1);
    }

    char map2[SIZE][SIZE];
    for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
            map2[i][2 * j] = map2[i][2 * j + 1] = map[i][j];
            if (map[i][j] == 'O') {
                map2[i][2 * j] = '[';
                map2[i][2 * j + 1] = ']';
            } else if (map[i][j] != '#') {
                map2[i][2 * j] = '.';
                map2[i][2 * j + 1] = '.';
            }
        }
    }

    int x, y;
    for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
            if (map[i][j] == '@') {
                x = i;
                y = j;
                map[i][j] = '.';
            }
        }
    }

    int x2 = x;
    int y2 = 2 * y;

    int c = 0;
    while ((c = fgetc(stdin)) != EOF) {
        int dx = 0, dy = 0;
        switch (c) {
        case '<':
            dy = -1;
            break;
        case '>':
            dy = 1;
            break;
        case '^':
            dx = -1;
            break;
        case 'v':
            dx = 1;
            break;
        default:
            continue;
        }
        int s = hole(x, y, dx, dy, map);
        if (s) {
            map[x + s * dx][y + s * dy] = 'O';
            map[x + dx][y + dy] = '.';
            x += dx;
            y += dy;
        }
        if (dy) {
            int s2 = hole(x2, y2, dx, dy, map2);
            if (s2) {
                if (s2 > 1)
                    move_line(y2 + dy, dy, s2 - 1, map2[x2]);
                y2 += dy;
            }
        } else {
            if (hole2(x2, y2, dx, map2)) {
                move2(x2, y2, dx, map2);
                x2 += dx;
            }
        }
    }

    int count1 = 0;
    for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
            putchar(map[i][j]);
            if (map[i][j] == 'O') {
                count1 += 100 * i + j;
            }
        }
        putchar('\n');
    }

    int count2 = 0;
    for (int i = 0; i < size; i++) {
        for (int j = 0; j < size * 2; j++) {
            putchar(map2[i][j]);
            if (map2[i][j] == '[') {
                count2 += 100 * i + j;
            }
        }
        putchar('\n');
    }

    printf("%d\n", count1);
    printf("%d\n", count2);
    return 0;
}