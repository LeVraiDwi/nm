#include "ft_nm.h"

int get_map_string(char   *path, t_map *map, t_nm *nm) {
    int fd;

    fd = ft_open(path);
    if (!fd) {
        rm_map(map);
        return -1; //error
    }
    if (fstat(fd, &map->buf)) {
        ft_close(fd);
        rm_map(map);
        ft_dprintf(2, "%s: %s: fail to get stats of the file\n", PROG_NAME, nm->arg.curr_filename);
        return -1; //error
    }
    map->addr = mmap(NULL, map->buf.st_size, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
    if (ft_close(fd)) {
        rm_map(map);
        ft_dprintf(2, "%s: %s: fail to close the file\n", PROG_NAME, nm->arg.curr_filename);
        return (-1); //error
    }
    if ((void *)map->addr == (void *)-1) {
        rm_map(map);
        ft_dprintf(2, "%s: %s: Wrong file type\n", PROG_NAME, nm->arg.curr_filename);
        return -1; //error
    }
    return 0;
}