#include "ft_nm.h"

int	ft_open(char *path) {
	int	fd;
	
	if (!path)
		return 0;
	fd = open(path, O_RDONLY);
	if (fd == 0) {
		write(2, PROG_NAME, ft_strlen(PROG_NAME));
        write(2, ": failed to open the file ", ft_strlen(": failed to open the file "));
        write(2, path, ft_strlen(path));
        write(2, "\n", 1);
		return 0;
	}
	if (fd < 0) {
		write(2, PROG_NAME, ft_strlen(PROG_NAME));
        write(2, ": permision denied ", ft_strlen(": permision denied "));
        write(2, path, ft_strlen(path));
        write(2, "\n", 1);
		return 0;
	}
	return fd;
}

int	ft_close(int fd) {
	if (fd > 0)
	if (close(fd))
		return (-1);
	return (0);
}