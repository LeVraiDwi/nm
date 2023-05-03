#ifndef FILE_STRUCT_H
#   define FILE_STRUCT_H
#   include <sys/types.h>
#   include <sys/stat.h>
#   include <unistd.h>
#   include <stdlib.h>

typedef struct s_file {
    struct stat	buf;
	void 		*addr;
} t_file;

t_file  *new_file(void);
void    rm_file(t_file *file);
#endif