SRCS=$(wildcard *.c)
OBJS=$(SRCS:.c=.o)
LIBS=pcre

CFLAGS=-g
LDFLAGS=$(addprefix -l,$(LIBS))

PROG=colour

all: $(PROG)
$(PROG): $(OBJS)
	$(CC) $(LDFLAGS) -o $@ $(OBJS)
%.o: %.c
	$(CC) -c $(CFLAGS) -o $@ $^
clean:
	rm -vfr $(PROG) $(OBJS)