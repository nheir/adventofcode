CFLAGS += -Wall -Wextra -std=c17

CFLAGS += -g -fsanitize=address,undefined
LDFLAGS += -fsanitize=address,undefined

all: 01 02 03 04 05 06 07

05 06 07: utils.o
05.o 06.o 07.o: utils.h