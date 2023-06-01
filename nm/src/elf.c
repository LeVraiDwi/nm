#include "ft_nm.h"

int set_elf_header(t_nm *nm) {
    nm->elf_data.elf_class = nm->map.addr[EI_CLASS];
    if (nm->elf_data.elf_class == ELFCLASS32) {
        nm->elf_data.elf_header.ehdr_32 = (Elf32_Ehdr *)nm->map.addr;
        if (nm->elf_data.elf_header.ehdr_32->e_shoff > (size_t) nm->map.buf.st_size) {            
            ft_dprintf(2, "%s: %s: invalide section header offset\n", PROG_NAME, nm->arg.curr_filename);
            return -1; //error
        }     
    }
    else if (nm->elf_data.elf_class == ELFCLASS64) {
        nm->elf_data.elf_header.ehdr_64 = (Elf64_Ehdr *)nm->map.addr;
        if (nm->elf_data.elf_header.ehdr_64->e_shoff > (size_t) nm->map.buf.st_size) {
            ft_dprintf(2, "%s: %s: invalide section header offset\n", PROG_NAME, nm->arg.curr_filename);
            return -1; //error
        }
    }
    return 0;
}

int set_elf_section_header(t_elf_data *elf_data, t_map *map) {
    if (elf_data->elf_class == ELFCLASS32) {
        elf_data->elf_section_header.shdr_32 = (Elf32_Shdr *) (map->addr + elf_data->elf_header.ehdr_32->e_shoff);
    }
    else if (elf_data->elf_class == ELFCLASS64) {
        elf_data->elf_section_header.shdr_64 = (Elf64_Shdr *) (map->addr + elf_data->elf_header.ehdr_64->e_shoff);
    }
    return 0;
}

int find_symbole_strtab(t_nm *nm, t_elf_data *elf_data) {
    size_t      e_phnum;
    uint32_t    sh_type;
    size_t      e_shentsize;
    size_t      max_shnum;

    e_phnum = get_number_of_section(elf_data);
    
    e_shentsize = nm->elf_data.elf_class == ELFCLASS32 ? sizeof(Elf32_Shdr) : sizeof(Elf64_Shdr);
    max_shnum = nm->map.buf.st_size / e_shentsize;
    if (e_phnum > max_shnum) {
        ft_dprintf(2, "%s: %s: e_shnum is corruped or invalid\n", PROG_NAME, nm->arg.curr_filename);
        return -1;
    }
    for (size_t i = 0; i < e_phnum; i++) {
        if (elf_data->elf_class == ELFCLASS32)
            sh_type = elf_data->elf_section_header.shdr_32[i].sh_type;
        else if (elf_data->elf_class == ELFCLASS64)
            sh_type = elf_data->elf_section_header.shdr_64[i].sh_type;
        if (sh_type == SHT_SYMTAB) {
            if (elf_data->elf_class == ELFCLASS32) {
                elf_data->elf_section_symtab.shdr_32 = &elf_data->elf_section_header.shdr_32[i];
                elf_data->elf_section_symtab_strtab.shdr_32 = &elf_data->elf_section_header.shdr_32[elf_data->elf_section_header.shdr_32[i].sh_link];
            } else if (elf_data->elf_class == ELFCLASS64) {
                elf_data->elf_section_symtab.shdr_64 = &elf_data->elf_section_header.shdr_64[i];
                elf_data->elf_section_symtab_strtab.shdr_64 = &elf_data->elf_section_header.shdr_64[elf_data->elf_section_header.shdr_64[i].sh_link];
            }
        } else if (sh_type == SHT_STRTAB) {
            if (elf_data->elf_class == ELFCLASS32) {
                elf_data->elf_section_strtab.shdr_32 = &elf_data->elf_section_header.shdr_32[i];
            } else if (elf_data->elf_class == ELFCLASS64) {
                elf_data->elf_section_strtab.shdr_64 = &elf_data->elf_section_header.shdr_64[i];
            }
        }
    }
    return 0;
}

int get_sym_data(t_elf_data *elf_data, t_map map) {
    if (elf_data->elf_class == ELFCLASS32) {
       elf_data->elf_symbol.sym_32 = (Elf32_Sym *)(map.addr + elf_data->elf_section_symtab.shdr_32->sh_offset);
    } else if (elf_data->elf_class == ELFCLASS64) {
       elf_data->elf_symbol.sym_64 = (Elf64_Sym *)(map.addr + elf_data->elf_section_symtab.shdr_64->sh_offset);
    }
    return 0;
}

int get_nb_tab(t_nm *nm) {
    if (nm->elf_data.elf_class == ELF_CLASS_32) {
        return nm->elf_data.elf_section_symtab.shdr_32->sh_size / sizeof(Elf32_Sym);
    } else if (nm->elf_data.elf_class == ELF_CLASS_64) {
        return nm->elf_data.elf_section_symtab.shdr_64->sh_size / sizeof(Elf64_Sym);
    }
    return 0;
}

int print_file_sym(t_nm *nm) {
    if (set_elf_header(nm))
        return -1; //err
    if (set_elf_section_header(&nm->elf_data, &nm->map))
        return -1; //err
    if(find_symbole_strtab(nm, &nm->elf_data))
        return -1; //err
    if (!check_symtab_strtab(nm))
        return -1;
    nm->elf_data.nb_tab = get_nb_tab(nm);
    if (get_sym_data(&nm->elf_data, nm->map))
        return -1; //err
    bubble_sort(nm->elf_data, &nm->map);
    return 0;
}