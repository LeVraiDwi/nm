#ifndef FILE_H
#   define FILE_H
#   include <sys/types.h>
#   include <sys/stat.h>
#   include <fcntl.h>
#   include <unistd.h>

int ft_open(char *path);
int ft_close(int fd);
#endif