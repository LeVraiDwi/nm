#include "ft_nm.h"

void    init_elf_header(t_elf_header *elf_header) {
    elf_header->ehdr_64 = NULL;
    elf_header->ehdr_32 = NULL;
}

void    init_elf_section_header(t_elf_section_header *elf_section_header) {
    elf_section_header->shdr_64 = NULL;
    elf_section_header->shdr_32 = NULL;
}

void    init_data (t_elf_data *elf_data) {
    init_elf_header(&elf_data->elf_header);
    init_elf_section_header(&elf_data->elf_section_header);
    elf_data->elf_class = ELF_CLASS_NONE;
}

size_t  get_number_of_section(t_elf_data *elf_data) {
    if (elf_data->elf_class == ELFCLASS32)
        return elf_data->elf_header.ehdr_32->e_phnum;
    else if (elf_data->elf_class == ELFCLASS64)
        return elf_data->elf_header.ehdr_64->e_phnum;
    return 0;
}