#include "ft_nm.h"

int set_elf_header(t_elf_data *elf_data, const t_map map) {
    elf_data->elf_class = map.addr[EI_CLASS];
    if (elf_data->elf_class == ELFCLASS32) {
        elf_data->elf_header.ehdr_32 = (Elf32_Ehdr *)map.addr;
        if (elf_data->elf_header.ehdr_32->e_phoff > (size_t) map.buf.st_size)
            return -1; //error
    }
    else if (elf_data->elf_class == ELFCLASS64) {
        elf_data->elf_header.ehdr_64 = (Elf64_Ehdr *)map.addr;
        if (elf_data->elf_header.ehdr_64->e_phoff > (size_t) map.buf.st_size)
            return -1; //error
    }
    return 0;
}

int set_elf_section_header(t_elf_data *elf_data, const t_map map) {
    if (elf_data->elf_class == ELFCLASS32) {
        elf_data->elf_section_header.shdr_32 = (Elf32_Shdr *) (map.addr + elf_data->elf_header.ehdr_32->e_shoff);
    }
    else if (elf_data->elf_class == ELFCLASS64) {
        elf_data->elf_section_header.shdr_64 = (Elf64_Shdr *) (map.addr + elf_data->elf_header.ehdr_64->e_shoff);
    }
    return 0;
}

int find_symbole_strtab(t_elf_data *elf_data) {
    size_t      e_phnum;
    uint32_t   sh_type;

    e_phnum = get_number_of_section(elf_data);
    //verifier si taille du fichier buff->st_size est superieur egale a e_phnum * e_shentsize sinon file corrupte
    for (unsigned int i = 0; i < e_phnum; i++) {
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

int print_file_sym(t_nm *nm) {
    if (set_elf_header(&nm->elf_data, nm->map))
        return -1; //err
    if (set_elf_section_header(&nm->elf_data, nm->map))
        return -1; //err
    if(find_symbole_strtab(&nm->elf_data))
        return -1; //err
    if (get_sym_data(&nm->elf_data, nm->map))
        return -1; //err
    //char *name = (char *)(nm->map.addr + nm->elf_data.elf_section_symtab_strtab.shdr_64->sh_offset + nm->elf_data.elf_symbol.sym_64->st_name);
    //printf("%s\n", name);
    return 0;
}