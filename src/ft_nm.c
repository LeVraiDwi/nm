#include "ft_nm.h"

int main(int argc, char **argv) {
	t_nm		nm;
	int			i;
	char		*name;

	init_nm(&nm);
	if (parsing_arg(argv, argc, &nm))
		return -1; //error
	i = 0;	
	while (i < nm.arg.nb_file) {
		//printf("parsing arg: %s\n", nm.arg.file_lst[0]);
		if (get_map_string(nm.arg.file_lst[i], &nm.map))
			return -1; //error
		print_file_sym(&nm);
		//printf("class: %d\n", nm.elf_data.elf_class);
		//printf("e_shoff: %ld\n", nm.elf_data.elf_header.ehdr_64->e_shoff);
		//printf("type: %x\n", nm.elf_data.elf_header.ehdr_64->e_type);
		//printf("version: %x\n", nm.elf_data.elf_header.ehdr_64->e_version);
		//printf("nb section: %x\n", nm.elf_data.elf_header.ehdr_64->e_shnum);
		//printf("section addr: %ld\n", nm.elf_data.elf_section_header.shdr_64->sh_addr);
		//l = nm.elf_data.elf_header.ehdr_64->e_shstrndx + nm.elf_data.elf_section_header.shdr_64->sh_name;
		//printf("section name: %s\n",  nm.map.addr + nm.elf_data.elf_header.ehdr_64->e_shstrndx + nm.elf_data.elf_section_header.shdr_64->sh_name);
		//printf("%s\n", nm.map.addr +  nm.elf_data.elf_symbol.sym_64[10].st_name);
		int nboftab = nm.elf_data.elf_section_symtab.shdr_64->sh_size / sizeof(Elf64_Sym);
		//printf("nb entry: %d\n%ld\n", nboftab, nm.elf_data.elf_section_symtab.shdr_64->sh_size);
		for (int i = 0; i < nboftab; i++) {
			name = get_sym_name(nm.elf_data, &nm.map, i);
			if (is_display(nm.elf_data, name, i))
				printf("%s | %d\n", name, get_char(nm.elf_data, i));
		}
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
