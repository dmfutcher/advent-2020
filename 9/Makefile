CC=clang
CFLAGS=-Wall

part1:
	$(CC) $(CFLAGS) -o part1 part1.c
	./part1

part2:
	$(CC) $(CFLAGS) -D NO_PART1_MAIN -o part1 part2.c part1.c
	./part1

.PHONY: part1 part2
