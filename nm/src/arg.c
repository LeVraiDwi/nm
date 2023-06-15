#include "ft_nm.h"

int parsing_arg(char **argv, int argc, t_nm *nm) {
    int     i;
    char    *tmp;

    i = 1;
    nm->arg.flag = FLAG_NULL;
    nm->arg.sort_flag = FLAG_NULL;
    while (i < argc) {
        tmp = argv[i++];

        if(tmp[0] == '-' && tmp[1]) {
            if (!parse_flag(tmp, nm)) {
                return -1; //error msg to many file
            }
        }
        else if (add_file(tmp, nm)) {
            ft_dprintf(2, "%s: to many file\n", PROG_NAME);
            return -1; //error msg to many file
        } 
    }
    if (nm->arg.nb_file == 0)
        if (add_file("a.out", nm)) {
            ft_dprintf(2, "%s: to many file\n", PROG_NAME);
            return -1; //error msg to many file
        }
    return 0;
}

unsigned int    add_file(char *tmp, t_nm *nm) {
    if (nm->arg.nb_file < MAX_NB_FILE) {
        nm->arg.file_lst[nm->arg.nb_file++] = tmp;
        nm->arg.curr_filename = tmp;
        return 0;
    }
    return -1;
}

void    init_arg(t_arg *arg) {
    arg->flag = 0;
    arg->nb_file = 0;
    ft_bzero((void *)arg->file_lst, sizeof(arg->file_lst));
}

void    rm_arg(t_arg *arg) {
    arg->flag = 0;
    arg->nb_file = 0;
    ft_bzero((void *)arg->file_lst, MAX_NB_FILE);
}

void add_flag(unsigned int add, unsigned int *flag) {
    if (!(*flag & add)) {
        *flag += add;
    }
    return;
}

void rm_flag(unsigned int add, unsigned int *flag) {
    if ((*flag & add)) {
        *flag -= add;
    }
    return;
}

bool    parse_flag(char *tmp, t_nm *nm) {

    for (size_t i = 1; tmp[i]; i++) {
        if (tmp[i] == 'a')
            add_flag(FLAG_A, &nm->arg.flag);
        else if (tmp[i] == 'g')
            add_flag(FLAG_G, &nm->arg.flag);
        else if (tmp[i] == 'u')
            add_flag(FLAG_U, &nm->arg.flag);
        else if (tmp[i] == 'r') {
            if (!(FLAG_P & nm->arg.sort_flag))
                nm->arg.sort_flag = FLAG_R;
        }
        else if (tmp[i] == 'p')
            nm->arg.sort_flag = FLAG_P;
        else {
            ft_dprintf(2, "%s: %c flag not manage\nlist of symbols:\n\
                a: display debug symbols\n\
                g: display only external symbols\n\
                u: display undefined symbols only\n\
                r: reverse the order of the sort\n\
                p: do not sort the symbols\n", PROG_NAME, tmp[i]);
            return false;
        }
    }
    return true;
}

// unsigned int check_arg(char *arg) {
//     int             i;
//     int             j;
//     unsigned int    flag;

//     i = 1;
//     while (arg[i]) {
//         j = 0;
//         flag = false;
//         while (j < NB_TOKEN) {
//             if (arg[i] == TOKEN[j])
//                 flag = true;
//             j++;
//         }
//         if (!flag)
//             return i;
//     i++;   
//     }
//     return 0;
// }