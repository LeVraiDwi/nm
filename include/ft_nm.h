#ifndef FT_NM_H
#   define FT_NM_H
#   define PROG_NAME "ft_nm"
#   define ARG_H
#   define MAX_NB_FILE 256
#   define FLAG_NULL 0
#   define FLAG_A 2
#   define FLAG_G 4
#   define FLAG_P 8
#   define FLAG_R 16
#   define FLAG_D 32
#   define FLAG_H 64
#   define FLAG_0 128
#   define TOKEN "AoaDghpru"
#   define NB_TOKEN 9
#   define  STRING_ARG ["print-file-name","debug-syms", "dynamic", "extern-only", "help", "no-sort", "undefined-only"]

#   include <stdio.h>
#   include <sys/mman.h>
#   include <sys/types.h>
#   include <sys/stat.h>
#   include <unistd.h>
#   include <fcntl.h>
#   include "libft.h"

typedef struct s_arg {
    unsigned int    flag;
    int             nb_file;
    char            *file_lst[MAX_NB_FILE];
}   t_arg;

typedef struct s_map {
    struct stat	buf;
	void 		*addr;
} t_map;

typedef struct s_nm {
    t_arg   arg;
    t_map   map;
}   t_nm;


int             parsing_arg(char **argv, int argc, t_nm *nm);
int             get_map_string(char   *path, t_map  *map);
int             ft_open(char *path);
int             ft_close(int fd);


unsigned int    add_file(char *tmp, t_nm *nm);

void            init_arg(t_arg *arg);
void            rm_arg(t_arg *arg);
void	        init_nm(t_nm *nm);
void	        rm_nm(t_nm *nm);
void            init_map(t_map   *map);
void            rm_map(t_map *map);
#endif