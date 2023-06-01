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