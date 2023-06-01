#include "ft_nm.h"

void    swap_symbole(t_elf_data elf_data, int sym_index, int sym_index_) {
    Elf32_Sym   sym32;
    Elf64_Sym   sym64;

    if (elf_data.elf_class == ELFCLASS32) {
        sym32 = elf_data.elf_symbol.sym_32[sym_index];
        elf_data.elf_symbol.sym_32[sym_index] = elf_data.elf_symbol.sym_32[sym_index_];
        elf_data.elf_symbol.sym_32[sym_index_] = sym32; 
    } else if (elf_data.elf_class == ELFCLASS64) {
        sym64 = elf_data.elf_symbol.sym_64[sym_index];
        elf_data.elf_symbol.sym_64[sym_index] = elf_data.elf_symbol.sym_64[sym_index_];
        elf_data.elf_symbol.sym_64[sym_index_] = sym64; 
    }
}

void    bubble_sort(t_elf_data elf_data, t_map *map) {
    bool swapped;

    for (size_t i = 0; i < elf_data.nb_tab - 1; i++) {
        swapped = false;
        for (size_t j = 0; j < elf_data.nb_tab - 1; j++) {
            if (ft_strcmp(get_sym_name(elf_data, map, j), get_sym_name(elf_data, map, j + 1)) > 0) {
                swap_symbole(elf_data, j, j + 1);
                swapped = true;
            }
        }
        if (!swapped)
            break;
    }
}