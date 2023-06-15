#include "ft_nm.h"

bool    display_value(uint64_t value, char sym) {
    
    if (sym == 'b' || sym == 'T' || sym == 'B' || sym == 'r')
        return true;
    else if (value == 0)
        return false;
    return true;
}

int     is_display(t_elf_data elf_data, char *name, int i) {
    unsigned char   type;
    unsigned char   bind;
    uint16_t        addr;


    //display all global and weak symbols, and local symbols
    //except STT_NOTYPE, UNDEF and STT_SECTION

    if (elf_data.elf_class == ELFCLASS32) {
        type = ELF32_ST_TYPE(elf_data.elf_symbol.sym_32[i].st_info);
        bind = ELF32_ST_BIND(elf_data.elf_symbol.sym_32[i].st_info);
        addr = elf_data.elf_symbol.sym_32[i].st_shndx;
    } else if (elf_data.elf_class == ELFCLASS64) {
        type = ELF64_ST_TYPE(elf_data.elf_symbol.sym_64[i].st_info);
        bind = ELF64_ST_BIND(elf_data.elf_symbol.sym_64[i].st_info);
        addr = elf_data.elf_symbol.sym_64[i].st_shndx;
    }
    // if ((ft_strncmp(name, "$", 1) == 0) || (name[0] == '\0' && addr == SHN_UNDEF))
    if ((name[0] == '\0' && addr == SHN_UNDEF))
        return 0;
    if ((type != STT_SECTION) &&
        (bind == STB_GLOBAL || bind == STB_WEAK ||
        (bind == STB_LOCAL && addr != SHN_UNDEF && type != STT_FILE)))
        return 1;
    return 0;
}

void display_sym(t_nm nm) {
    uint64_t	value;
	char		*name;
    char        sym;

    if (nm.arg.nb_file > 1)
					ft_dprintf(1, "%s:\n", nm.arg.curr_filename);
		for (size_t i = 0; i < nm.elf_data.nb_tab; i++) {
			name = get_sym_name(nm.elf_data, &nm.map, i);
			value = get_value(nm.elf_data, i);
            sym = get_char(nm.elf_data, name, i);
			if (is_display(nm.elf_data, name, i)) {
				if (nm.elf_data.elf_class == ELFCLASS64) {
					if (display_value(value, sym))
						ft_dprintf(1, "%.16x %c %s\n", value, sym, name);
					else
						ft_dprintf(1, "%16s %c %s\n", "\0", sym, name);
				}
				else if (nm.elf_data.elf_class == ELFCLASS32) {
					if (display_value(value, sym))
						ft_dprintf(1, "%.8x %c %s\n", value, sym, name);
					else
						ft_dprintf(1, "%8s %c %s\n", "\0", sym, name);
				}
				else
					return;
			}
		}
}