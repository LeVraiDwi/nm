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
#   include <elf.h>
#   include "libft.h"

typedef enum e_elf_class {
    ELF_CLASS_NONE = 0,
    ELF_CLASS_32 = 1,
    ELF_CLASS_64 = 2,
} t_elf_class;

typedef union u_elf_header {
    Elf32_Ehdr  *ehdr_32;
    Elf64_Ehdr  *ehdr_64;
}   t_elf_header;

typedef union u_elf_section_header {
    Elf32_Shdr  *shdr_32;
    Elf64_Shdr  *shdr_64;
}   t_elf_section_header;

typedef union u_elf_symbol {
    Elf32_Sym   *sym_32;
    Elf64_Sym   *sym_64;
}   t_elf_symbol;

typedef struct s_elf_data {
    t_elf_header            elf_header;
    t_elf_section_header    elf_section_header;
    t_elf_class             elf_class;
    t_elf_section_header    elf_section_strtab;
    t_elf_section_header    elf_section_symtab;
    t_elf_section_header    elf_section_symtab_strtab;
    t_elf_symbol            elf_current_symbol;
    t_elf_symbol            elf_symbol;
} t_elf_data;

typedef struct s_arg {
    unsigned int    flag;
    int             nb_file;
    char            *file_lst[MAX_NB_FILE];
}   t_arg;

typedef struct s_map {
    struct stat     buf;
	unsigned char   *addr;
} t_map;

typedef struct s_nm {
    t_arg       arg;
    t_map       map;
    t_elf_data  elf_data;
}   t_nm;

int             parsing_arg(char **argv, int argc, t_nm *nm);
int             get_map_string(char   *path, t_map  *map);
int             ft_open(char *path);
int             ft_close(int fd);
int             set_elf_header(t_elf_data *elf_data, t_map map);
int             set_elf_section_header(t_elf_data *elf_data, const t_map map);
int             find_symbole_strtab(t_elf_data *elf_data);
int             get_sym_data(t_elf_data *elf_data, t_map map);
int             print_file_sym(t_nm *nm);

unsigned int    add_file(char *tmp, t_nm *nm);

size_t  get_number_of_section(t_elf_data *elf_data);

void            init_arg(t_arg *arg);
void            rm_arg(t_arg *arg);
void	        init_nm(t_nm *nm);
void	        rm_nm(t_nm *nm);
void            init_map(t_map   *map);
void            rm_map(t_map *map);
void            init_elf_header(t_elf_header *elf_header);
void            init_data (t_elf_data *elf_data);
void            init_elf_section_header(t_elf_section_header *elf_section_header);
#endif