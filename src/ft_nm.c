#include "ft_nm.h"

int main(int argc, char **argv) {
	t_nm		nm;
	int			i;

	init_nm(&nm);
	if (parsing_arg(argv, argc, &nm))
		return -1; //error
	i = 0;	
	while (i < nm.arg.nb_file) {
		printf("parsing arg: %s\n", nm.arg.file_lst[0]);
		if (get_map_string(nm.arg.file_lst[i], &nm.map))
			return -1; //error
		print_file_sym(&nm);
		printf("class: %d\n", nm.elf_data.elf_class);
		printf("e_shoff: %ld\n", nm.elf_data.elf_header.ehdr_64->e_shoff);
		printf("type: %x\n", nm.elf_data.elf_header.ehdr_64->e_type);
		printf("version: %x\n", nm.elf_data.elf_header.ehdr_64->e_version);
		printf("nb section: %x\n", nm.elf_data.elf_header.ehdr_64->e_shnum);
		printf("section addr: %ld\n", nm.elf_data.elf_section_header.shdr_64->sh_addr);
		//l = nm.elf_data.elf_header.ehdr_64->e_shstrndx + nm.elf_data.elf_section_header.shdr_64->sh_name;
		//printf("section name: %s\n",  nm.map.addr + nm.elf_data.elf_header.ehdr_64->e_shstrndx + nm.elf_data.elf_section_header.shdr_64->sh_name);
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
