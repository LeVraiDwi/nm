#include "ft_nm.h"

int main(int argc, char **argv) {
	t_nm		nm;
	int			i;
	

	init_nm(&nm);
	if (parsing_arg(argv, argc, &nm))
		return -1; //error
	i = 0;	
	while (i < nm.arg.nb_file) {
		//printf("parsing arg: %s\n", nm.arg.file_lst[0]);
		if (i > 0)
			ft_dprintf(1, "\n");
		if (get_map_string(nm.arg.file_lst[i], &nm.map, &nm)) {
			i++;
			continue;
		}
		if (!check_header(&nm)) {
			rm_map(&nm.map);
			i++;
			continue;
		}
		init_data(&nm.elf_data);
		if (print_file_sym(&nm)) {
			rm_map(&nm.map);
			i++;
			continue;
		}
		display_sym(nm);
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
