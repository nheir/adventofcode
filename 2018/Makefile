SRCS = $(sort $(wildcard *.in))
TEST = $(SRCS:.in=.out)

all : $(TEST)

$(TEST) : %.out: % %.1.lua %.2.lua
	@echo -n "Day $<.1: "
	@lua $<.1.lua < $<.in
	@echo -n "Day $<.2: "
	@lua $<.2.lua < $<.in

$(SRCS:.in=):

$(SRCS:.in=.1.lua) $(SRCS:.in=.2.lua):
	touch $@
