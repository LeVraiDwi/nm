#include "file.h"

int	ft_open(char *path) {
	int	fd;
	
	if (!path)
		return 0;
	fd = open(path, O_RDONLY);
	if (!fd)
		return 0;
	return fd;
}

int	ft_close(int fd) {
	if (fd > 0)
	if (close(fd))
		return (-1);
	return (0);
}