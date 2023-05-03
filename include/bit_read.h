#ifndef BIT_READ_H
#   define BIT_READ_H
#   include <sys/mman.h>
#   include <sys/types.h>
#   include <sys/stat.h>
#   include <unistd.h>
#   include "file.h"
#   include "file_struct.h"

t_file  *get_file_string(char   *path);
#endif