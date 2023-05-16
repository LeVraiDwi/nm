#include "ft_nm.h"

int parsing_arg(char **argv, int argc, t_nm *nm) {
    int     i;
    char    *tmp;

    i = 1;
    while (i < argc) {
        tmp = argv[i++];
        if (add_file(tmp, nm))
            return -1; //error msg to many file
    }
    if (nm->arg.nb_file == 0)
        if (add_file("a.out", nm))
            return -1; //error msg to many file
    return 0;
}

unsigned int    add_file(char *tmp, t_nm *nm) {
    if (nm->arg.nb_file < MAX_NB_FILE) {
        nm->arg.file_lst[nm->arg.nb_file++] = tmp;
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

// void add_flag(unsigned int flag, t_nm *nm) {
//     if (!nm->arg.flag & flag) {
//         nm->arg.flag += flag;
//     }
//     return 0;
// }

// void rm_flag(unsigned int flag, t_nm *nm) {
//     if (nm->arg.flag & flag) {
//         nm->arg.flag -= flag;
//     }
//     return 0;
// }

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