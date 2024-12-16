CFLAGS += -Wall -Wextra -std=c17 -fno-strict-aliasing

CFLAGS += -g -fsanitize=address,undefined
LDFLAGS += -fsanitize=address,undefined

all: 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16

05 06 07 08 09 10 12: utils.o
05.o 06.o 07.o 08.o 09.o 10.c 12.c: utils.h