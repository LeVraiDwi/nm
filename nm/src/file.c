#include "ft_nm.h"

int	ft_open(char *path) {
	int	fd;
	
	if (!path)
		return 0;
	fd = open(path, O_RDONLY);
	if (fd == 0) {
		ft_dprintf(2, "%s: %s: failed to open the file\n", PROG_NAME, path);
		return 0;
	}
	if (fd < 0) {
		ft_dprintf(2, "%s: %s: failed to open the file\n", PROG_NAME, path);
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