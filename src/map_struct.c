#include "ft_nm.h"

void    init_map(t_map   *map) {
    map->addr = 0;
}

void    rm_map(t_map *map) {
    if (map->addr)
        munmap(map->addr, map->buf.st_size);
    map->addr = 0;
    return;
}