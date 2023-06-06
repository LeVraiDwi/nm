#include "ft_nm.h"

char get_char(t_elf_data elf_data, char *name, int i) {
    unsigned char   type;
    unsigned char   bind;
    uint16_t        addr;
    Elf32_Shdr      *elf32;
    Elf64_Shdr      *elf64;
    char            c;

    elf32 = (Elf32_Shdr *)NULL;
    elf64 = (Elf64_Shdr *)NULL;

    if (elf_data.elf_class == ELFCLASS32) {
        type = ELF32_ST_TYPE(elf_data.elf_symbol.sym_32[i].st_info);
        bind = ELF32_ST_BIND(elf_data.elf_symbol.sym_32[i].st_info);
        addr = elf_data.elf_symbol.sym_32[i].st_shndx;
        elf32 = (Elf32_Shdr *)&elf_data.elf_section_header.shdr_32[addr];
    } else if (elf_data.elf_class == ELFCLASS64) {
        type = ELF64_ST_TYPE(elf_data.elf_symbol.sym_64[i].st_info);
        bind = ELF64_ST_BIND(elf_data.elf_symbol.sym_64[i].st_info);
        addr = elf_data.elf_symbol.sym_64[i].st_shndx;
        elf64 = (Elf64_Shdr *)&elf_data.elf_section_header.shdr_64[addr];
    }
    else 
        return '\0';

    if (addr == SHN_UNDEF) {
        if (bind == STB_WEAK)
            if (type == STT_OBJECT)
                return 'v';
            else
                return 'w';
        else
            return 'U';
    } else if (addr == SHN_ABS) {
        return bind == STB_LOCAL ? 'a':'A';
    } else if (addr == SHN_COMMON) {
        return 'C';
    } else if (ft_strncmp(name, ".debug", 6) == 0) {
        return 'N';
    }
    
    if (elf32 || elf64) {
        if (elf_data.elf_class == ELFCLASS32) {
            if (elf32->sh_type == SHT_NOBITS && elf32->sh_flags & SHF_ALLOC && elf32->sh_flags & SHF_WRITE)
                c = 'B';
            else if (elf32->sh_type == SHT_PROGBITS) {
                if (elf32->sh_flags & SHF_WRITE)
                    c = 'D';
                else if (elf32->sh_flags & SHF_EXECINSTR)
                    c = 'T';
                else if (elf32->sh_flags & SHF_ALLOC)
                    c = 'R';
                else
                    return 'n';
            } else if (elf32->sh_type == SHT_PREINIT_ARRAY) {
                c = 'D';
            }else if (elf32->sh_type == SHT_INIT_ARRAY) {
                c = 'D';
            }else if (elf32->sh_type == SHT_DYNAMIC) {
                c = 'D';
            }else if (elf32->sh_type == SHT_FINI_ARRAY) {
                c = 'D';
            } else {
                if (elf32->sh_flags & SHF_ALLOC && !(elf32->sh_flags & SHF_WRITE) && !(elf32->sh_flags & SHF_EXECINSTR))
                    c = 'R';
                else
                    c = 'n';
            }
        }
        else if (elf_data.elf_class == ELFCLASS64) {
            if (elf64->sh_type == SHT_NOBITS && (elf64->sh_flags & SHF_ALLOC) && (elf64->sh_flags & SHF_WRITE))
                c = 'B';
            else if (elf64->sh_type == SHT_PROGBITS) {
                if (elf64->sh_flags & SHF_WRITE)
                    c = 'D';
                else if (elf64->sh_flags & SHF_EXECINSTR)
                    c = 'T';
                else if (elf64->sh_flags & SHF_ALLOC)
                    c = 'R';
                else
                    return 'n';
            } else if (elf64->sh_type == SHT_PREINIT_ARRAY) {
                c = 'D';
            }else if (elf64->sh_type == SHT_INIT_ARRAY) {
                c = 'D';
            }else if (elf64->sh_type == SHT_DYNAMIC) {
                c = 'D';
            }else if (elf64->sh_type == SHT_FINI_ARRAY) {
                c = 'D';
            } else {
                if (elf64->sh_flags & SHF_ALLOC && !(elf64->sh_flags & SHF_WRITE) && !(elf64->sh_flags & SHF_EXECINSTR))
                    c = 'R';
                else
                    c = 'n';
            }
        }
    }
        
        if (bind == STB_WEAK) {
            if (type == STT_OBJECT)
                c = 'V';
            else
                c = 'W';
        }
        if (bind == STB_LOCAL)
            c = ft_tolower(c);
        return c;
}

char    *get_sym_name(t_elf_data elf_data, t_map *map, int i) {
    Elf32_Shdr shdr32;
    Elf64_Shdr shdr64;

    if (elf_data.elf_class == ELFCLASS32) {
        if (ELF32_ST_TYPE(elf_data.elf_symbol.sym_32[i].st_info) == STT_SECTION) {
            shdr32 = elf_data.elf_section_header.shdr_32[elf_data.elf_symbol.sym_32[i].st_shndx];
            return ((char *)(map->addr + elf_data.elf_symbol.sym_32[i].st_name + shdr32.sh_offset));
        }
        return ((char *)(map->addr + elf_data.elf_section_symtab_strtab.shdr_32->sh_offset + elf_data.elf_symbol.sym_32[i].st_name));
    } else if (elf_data.elf_class == ELFCLASS64) {
        if (ELF64_ST_TYPE(elf_data.elf_symbol.sym_64[i].st_info) == STT_SECTION) {
            shdr64 = elf_data.elf_section_header.shdr_64[elf_data.elf_symbol.sym_64[i].st_shndx];
            return ((char *)(map->addr + elf_data.elf_symbol.sym_64[i].st_name + shdr64.sh_offset));
        }
        return ((char *)(map->addr + elf_data.elf_section_symtab_strtab.shdr_64->sh_offset + elf_data.elf_symbol.sym_64[i].st_name));
    }
    return (char *)NULL;
}

uint64_t    get_value(t_elf_data elf_data, int i) {
    uint64_t addr;

    addr = 0;
    if (elf_data.elf_class == ELFCLASS32) {
        addr = elf_data.elf_symbol.sym_32[i].st_value;
    }else if (elf_data.elf_class == ELFCLASS64) {
        addr = elf_data.elf_symbol.sym_64[i].st_value;
    }

    return addr;
}