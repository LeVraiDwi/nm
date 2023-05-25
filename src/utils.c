#include "ft_nm.h"

char get_char(t_elf_data elf_data, int i) {
    unsigned char   type;
    unsigned char   bind;

    if (elf_data.elf_class == ELFCLASS32) {
        type = ELF32_ST_TYPE(elf_data.elf_symbol.sym_32[i].st_info);
        bind = ELF32_ST_BIND(elf_data.elf_symbol.sym_32[i].st_info);
    } else if (elf_data.elf_class == ELFCLASS64) {
        type = ELF64_ST_TYPE(elf_data.elf_symbol.sym_64[i].st_info);
        bind = ELF64_ST_BIND(elf_data.elf_symbol.sym_64[i].st_info);
    }
    else 
        return '\0'; 
    if (type == STT_NOTYPE)
        return STT_NOTYPE;
    else if (type == STT_OBJECT)
        return STT_OBJECT;
    else if (type == STT_FUNC)
        return STT_FUNC;        
    else if (type == STT_SECTION)
        return STT_SECTION;
    else if (type == STT_FILE)
        return STT_FILE;
    else if (type == STT_LOPROC)
        return STT_LOPROC;
    else if (bind == STB_LOCAL)
        return STB_LOCAL + 10;
    else if (bind == STB_GLOBAL)
        return STB_GLOBAL + 10;
    else if (bind == STB_WEAK)
        return STB_WEAK + 10;
    else if (bind == STB_LOPROC)
        return STB_LOPROC + 10;
    else
        return '\0';
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
    if ((ft_strncmp(name, "$", 1) == 0) || (name[0] == '\0' && addr == SHN_UNDEF))
        return 0;
    if ((type != STT_SECTION) &&
        (bind == STB_GLOBAL || bind == STB_WEAK ||
        (bind == STB_LOCAL && addr != SHN_UNDEF && type != STT_FILE)))
        return 1;
    return 0;
}

char    *get_sym_name(t_elf_data elf_data, t_map *map, int i) {
    Elf32_Shdr shdr32;
    Elf64_Shdr shdr64;

    if (elf_data.elf_class == ELFCLASS32) {
        if (ELF32_ST_TYPE(elf_data.elf_symbol.sym_32[i].st_info) == STT_SECTION) {
            shdr32 = elf_data.elf_section_header.shdr_32[elf_data.elf_symbol.sym_32[i].st_shndx];
            return ((char *)(map->addr + elf_data.elf_section_strtab.shdr_32->sh_offset + shdr32.sh_name));
        }
        return ((char *)(map->addr + elf_data.elf_section_symtab_strtab.shdr_32->sh_offset + elf_data.elf_symbol.sym_32[i].st_name));
    } else if (elf_data.elf_class == ELFCLASS64) {
        if (ELF64_ST_TYPE(elf_data.elf_symbol.sym_64[i].st_info) == STT_SECTION) {
            shdr64 = elf_data.elf_section_header.shdr_64[elf_data.elf_symbol.sym_64[i].st_shndx];
            return ((char *)(map->addr + elf_data.elf_section_strtab.shdr_64->sh_offset + shdr64.sh_name));
        }
        return ((char *)(map->addr + elf_data.elf_section_symtab_strtab.shdr_64->sh_offset + elf_data.elf_symbol.sym_64[i].st_name));
    }
    return (char *)NULL;
}
