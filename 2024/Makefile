CFLAGS += -Wall -Wextra -std=c17

CFLAGS += -g -fsanitize=address,undefined
LDFLAGS += -fsanitize=address,undefined

all: 01 02 03 04 05 06

05 06: utils.o
05.o 06.o: utils.h