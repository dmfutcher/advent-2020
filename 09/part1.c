#include <stdio.h>
#include <stdlib.h>

const int PREAMBLE_LENGTH = 25;

int load_input(char *fname, long **vals) {
    FILE * fp;
    char * line = NULL;
    size_t len = 0;
    ssize_t read, items = 0;

    fp = fopen(fname, "r");
    if (fp == NULL)
        return -1;

    while (getline(&line, &len, fp) != -1) {
        items++;
    }

    *vals = malloc(sizeof(long) * items);
    if (*vals == NULL) {
        return -1;
    }

    rewind(fp);

    for (int i = 0; i < items; i++) {
        if ((read = getline(&line, &len, fp)) == -1) {
            free(*vals);
            return -1;
        }

        if (line[read - 1] == '\n')
            line[read - 1] = '\0';

        long line_val = atol(line);
        (*vals)[i] = line_val;
    }

    fclose(fp);
    if (line)
        free(line);
    
    return items;
}

int is_sum_of_preamble_items(long val, long *preamble) {
    for (int xi = 0; xi < PREAMBLE_LENGTH; xi++) {
        for (int yi = 1; yi < PREAMBLE_LENGTH; yi++) {
            int x = preamble[xi], y = preamble[yi];
            if (x == y) continue;

            if (x + y == val) {
                return 1;
            }
        }
    }

    return 0;
}

int first_non_sum(long *ptr) { 
    long *preamble = ptr;
    long *val = ptr + PREAMBLE_LENGTH;

    while (*val != 0) {
        if (is_sum_of_preamble_items(*val, preamble) == 0) {
            return *val;
        }

        val++;
        preamble++;
    }

    return -1;
}

#ifndef NO_PART1_MAIN

int main() {
    long *values = NULL;

    load_input("input", &values);
    int result = first_non_sum(values);
    printf("Answer: %i\n", result);

    free(values);
}

#endif
