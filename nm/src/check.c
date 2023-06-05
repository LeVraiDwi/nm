#include "ft_nm.h"

bool    check_magic_number(t_nm *nm) {
    if (!(nm->map.addr[0] == 0x7f && nm->map.addr[1] == 'E' && nm->map.addr[2] == 'L' && nm->map.addr[3] == 'F')) {
        ft_dprintf(2, "%s: %s: not ELF file\n", PROG_NAME, nm->arg.curr_filename);
        return false;
    }
    return true;
}

bool    check_ei_data(t_nm *nm) {
    if (nm->map.addr[EI_DATA] != ELFDATA2LSB && nm->map.addr[EI_DATA] != ELFDATA2MSB) {
        ft_dprintf(2, "%s: %s: Unsuported ELF file encoding\n", PROG_NAME, nm->arg.curr_filename);
        return false;
    }
    return true;
}

bool    check_class(t_nm *nm) {
    unsigned char elf_class = nm->map.addr[EI_CLASS];
    if (elf_class != ELFCLASS32 && elf_class != ELFCLASS64) {
        ft_dprintf(2, "%s: %s: Unsuported ELF file class\n", PROG_NAME, nm->arg.curr_filename);
        return false;
    }
    return true;
}

bool    check_os_abi(t_nm *nm) {
    if (nm->map.addr[EI_OSABI] > ELFOSABI_OPENBSD &&
            nm->map.addr[EI_OSABI] != ELFOSABI_ARM_AEABI &&
            nm->map.addr[EI_OSABI] != ELFOSABI_ARM &&
            nm->map.addr[EI_OSABI] != ELFOSABI_STANDALONE) {
                ft_dprintf(2, "%s: %s: Unsuported ELF file OS ABI\n", PROG_NAME, nm->arg.curr_filename);
        return false;
            }
    return true;
}

bool   check_version(t_nm *nm) {
    if (nm->map.addr[EI_VERSION] != EV_CURRENT) {
        ft_dprintf(2, "%s: %s: Unsuported ELF file version\n", PROG_NAME, nm->arg.curr_filename);
        return false;
    }
    return true;
}

bool    check_symtab_strtab(t_nm *nm) {
    if ((nm->elf_data.elf_class == ELFCLASS32 && !nm->elf_data.elf_section_symtab.shdr_32) ||
            (nm->elf_data.elf_class == ELFCLASS64 && !nm->elf_data.elf_section_symtab.shdr_64)) {
                ft_dprintf(2, "%s: %s: fail to find symbole tab\n", PROG_NAME, nm->arg.curr_filename);
                return false;
    }

    if ((nm->elf_data.elf_class == ELFCLASS32 && !nm->elf_data.elf_section_strtab.shdr_32) ||
            (nm->elf_data.elf_class == ELFCLASS64 && !nm->elf_data.elf_section_strtab.shdr_64)) {
                ft_dprintf(2, "%s: %s: fail to find string tab\n", PROG_NAME, nm->arg.curr_filename);
                return false;
    }

    if ((nm->elf_data.elf_class == ELFCLASS32 && !nm->elf_data.elf_section_symtab_strtab.shdr_32) ||
            (nm->elf_data.elf_class == ELFCLASS64 && !nm->elf_data.elf_section_symtab_strtab.shdr_64)) {
                ft_dprintf(2, "%s: %s: fail to find symbole sting tab\n", PROG_NAME, nm->arg.curr_filename);
                return false;
    }
    return true;
}

bool    check_symbol_name(t_nm *nm) {
    Elf32_Shdr shdr32;
    Elf64_Shdr shdr64;

    for (size_t i = 0; i < nm->elf_data.nb_tab; i++) {
        if (nm->elf_data.elf_class == ELFCLASS32) {
            if (ELF32_ST_TYPE(nm->elf_data.elf_symbol.sym_32[i].st_info) == STT_SECTION) {
                shdr32 = nm->elf_data.elf_section_header.shdr_32[nm->elf_data.elf_symbol.sym_32[i].st_shndx];
                printf("errrrrr: %u | %u\n", shdr32.sh_size, nm->elf_data.elf_symbol.sym_32[i].st_name);
                if (shdr32.sh_size < nm->elf_data.elf_symbol.sym_32[i].st_name && nm->elf_data.elf_symbol.sym_32[i].st_name) {
                    ft_dprintf(2, "%s: %s: e_stname is corruped or invalid\n", PROG_NAME, nm->arg.curr_filename);
                    return false;
                }
            }
            printf("err: %lu | %u\n", nm->elf_data.elf_section_symtab_strtab.shdr_64->sh_size, nm->elf_data.elf_symbol.sym_64[i].st_name);
            if (nm->elf_data.elf_section_symtab_strtab.shdr_64->sh_size < nm->elf_data.elf_symbol.sym_64[i].st_name && nm->elf_data.elf_symbol.sym_64[i].st_name) {
                ft_dprintf(2, "%s: %s: e_shtame is corruped or invalid\n", PROG_NAME, nm->arg.curr_filename);
                return false;
            }
        } else if (nm->elf_data.elf_class == ELFCLASS64) {
            if (ELF64_ST_TYPE(nm->elf_data.elf_symbol.sym_64[i].st_info) == STT_SECTION) {
                shdr64 = nm->elf_data.elf_section_header.shdr_64[nm->elf_data.elf_symbol.sym_64[i].st_shndx];
                printf("errrrrr: %lu | %u\n", shdr64.sh_size, nm->elf_data.elf_symbol.sym_64[i].st_name);
                if (shdr64.sh_size < nm->elf_data.elf_symbol.sym_64[i].st_name && nm->elf_data.elf_symbol.sym_64[i].st_name) {
                    ft_dprintf(2, "%s: %s: e_stname is corruped or invalid\n", PROG_NAME, nm->arg.curr_filename);
                    return false;
                }
            }
            printf("err: %lu | %u\n", nm->elf_data.elf_section_symtab_strtab.shdr_64->sh_size, nm->elf_data.elf_symbol.sym_64[i].st_name);
            if (nm->elf_data.elf_section_symtab_strtab.shdr_64->sh_size < nm->elf_data.elf_symbol.sym_64[i].st_name && nm->elf_data.elf_symbol.sym_64[i].st_name) {
                ft_dprintf(2, "%s: %s: e_shtame is corruped or invalid\n", PROG_NAME, nm->arg.curr_filename);
                return false;
            }
        }
    }
    return true;
}

bool    check_sh_name(t_nm *nm) {
   size_t       e_shnum;
    size_t      e_shentsize;
    size_t      max_shnum;
    //Elf32_Shdr  shdr32;
    Elf64_Shdr  shdr64;

    e_shnum = get_number_of_section(&nm->elf_data);
    
    e_shentsize = nm->elf_data.elf_class == ELFCLASS32 ? sizeof(Elf32_Shdr) : sizeof(Elf64_Shdr);
    max_shnum = nm->map.buf.st_size / e_shentsize;
    if (e_shnum > max_shnum) {
        ft_dprintf(2, "%s: %s: e_shnum is corruped or invalid\n", PROG_NAME, nm->arg.curr_filename);
        return false;
    }
    for (size_t i = 0; i < e_shnum; i++) {
        if (nm->elf_data.elf_class == ELFCLASS64) {
            shdr64 = nm->elf_data.elf_section_header.shdr_64[nm->elf_data.elf_header.ehdr_64->e_shstrndx];
            if (nm->elf_data.elf_section_header.shdr_64[i].sh_name) {
                if (nm->elf_data.elf_section_header.shdr_64[i].sh_name > shdr64.sh_size) {
                    ft_dprintf(2, "%s: %s: sh_name is corruped or invalid\n", PROG_NAME, nm->arg.curr_filename);
                    return false;
                }
            }
        }
    }
    return true;
}

bool check_header(t_nm *nm) {
    if (!check_magic_number(nm))
        return false;
    else if (!check_ei_data(nm))
        return false;
    else if (!check_class(nm))
        return false;
    else if (!check_os_abi(nm))
        return false;
    else if (!check_version(nm))
        return false;
    else
        return true;
}