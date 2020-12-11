#include <stdio.h>
#include <limits.h>

// Defined in part1.c
extern int load_input(char *fname, long **vals);

const long TARGET = 105950735;

int sum_to_target(long *base, int len) {
    long *end = base + len;
    long *ptr = base;

    long total = 0;
    while (ptr != end) {
        total = total + *ptr;
        ptr++;
    }

    return total == TARGET;
}

void span_min_max(long *base, int len, long *min_out, long *max_out) {
    long *end = base + len;
    long *ptr = base;

    long min = LONG_MAX;
    long max = LONG_MIN;

    while (ptr != end) {
        if (*ptr < min) 
            min = *ptr;

        if (*ptr > max) 
            max = *ptr;

        ptr++;
    }

    *min_out = min;
    *max_out = max;
}

int target_summing_span(long *vals, int count, long *min, long *max) {
    for (int base = 0; base < count; base++) {
        int max_len = count - base;
        for (int len = 0; len <= max_len; len++) {
            if (sum_to_target(vals + base, len) == 1) {
                span_min_max(vals + base, len, min, max);
                return 1;
            }
        }
    }

    return -1;
}

int main() {
    long *vals;
    int count = load_input("input", &vals);
    long min = 0, max = 0;
    target_summing_span(vals, count, &min, &max);

    printf("Answer: %lu\n", min + max);
}
