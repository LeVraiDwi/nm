#include "main.h"

int main(int argc, char **argv) {
	char		*tmp;
	int			i;
	t_file		*file;

	if (argc <= 1) {
		tmp = "a.out";
	}
	else
		tmp = argv[1];
	i = 1;
	while(i < argc || i == 1) {
		file = get_file_string(tmp);
		if (!file)
			return (-1);
		for (int n = 0; n < file->buf.st_size; n++)
			printf("offset: %d: %x\n", n, ((char *)file->addr)[n]);
		if (++i < argc)
			tmp = argv[i];
		rm_file(file);
	}
	return 0;
}
