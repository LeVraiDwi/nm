#include "ft_nm.h"

int main(int argc, char **argv) {
	t_nm		nm;
	int			i;

	init_nm(&nm);
	if (parsing_arg(argv, argc, &nm))
		return -1; //error
	i = 0;
	printf("parsing arg: %s\n", nm.arg.file_lst[0]);
	while (i < nm.arg.nb_file) {
		if (get_map_string(nm.arg.file_lst[i], &nm.map))
			return -1; //error
		for (int n = 0; n < nm.map.buf.st_size; n++)
			printf("offset: %d: %x\n", n, ((char *)nm.map.addr)[n]);
		rm_map(&nm.map);
		i++;
	}
	rm_nm(&nm);
	return 0;
}

void	init_nm(t_nm *nm) {
	init_arg(&nm->arg);
	init_map(&nm->map);
}

void	rm_nm(t_nm *nm) {
	rm_arg(&nm->arg);
	rm_map(&nm->map);
}
