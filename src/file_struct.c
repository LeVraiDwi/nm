#include "file_struct.h"

t_file  *new_file(void) {
    t_file  *file;

    file = malloc(sizeof(t_file) * 1);
    if (!file)
        return 0;
    return file;
}

void    rm_file(t_file *file) {
    if (!file)
        return;
    free(file);
    return;
}