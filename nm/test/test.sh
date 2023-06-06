#!/bin/sh

VERBOSE=1

TEST_LIB=0
TEST_BIN=0
TEST_ALL=1
TEST_OBJ=0

_GREEN=`tput setaf 2`
_YELLOW=`tput setaf 3`
_RED=`tput setaf 1`
_PURPLE=`tput setaf 5`
_END=`tput sgr0`

compare_nm_and_ft_nm_output() {
    test_name=$1
    test_number=$2
    prog=$3
    ft_nm_output=$4

    nm_output=$(nm "$prog" $options)
    if [ "$nm_output" = "$ft_nm_output" ]
    then
        echo "${_GREEN}[$test_number] ${test_name}: -> OK${_END}"
    else
        echo "${_RED}[$test_number] ${test_name}: -> KO${_END}"
        if [ "$VERBOSE" -eq 1 ]; then
            echo "${_YELLOW}--- nm output:${_END}"
            echo "$nm_output"
            echo "$nm_output" > nm_output.txt
            echo "${_YELLOW}--- ft_nm output:${_END}"
            echo "$ft_nm_output"
            echo "$ft_nm_output" > ft_nm_output.txt
            echo "${_YELLOW}--- diff:${_END}"
            diff nm_output.txt ft_nm_output.txt
            rm nm_output.txt ft_nm_output.txt
        fi
    fi
}

compare_ft_nm_error_with_expected_output() {
    test_name=$1
    test_number=$2
    expected_output=$3
    
    ft_nm_stderr=$(cat ./valgrind.out)
    if echo "$ft_nm_stderr" | grep -q "$expected_output"; then
        echo "${_GREEN}[${test_number}] ${test_name}: -> OK${_END}"
    else
        echo "${_RED}[${test_number}] ${test_name}: -> KO${_END}"
        if [ "$VERBOSE" -eq 1 ]; then
            echo "${_YELLOW}--- expected output:${_END}"
            echo "$expected_output"
            echo "${_YELLOW}--- ft_nm output:${_END}"
            echo "$ft_nm_stderr"
        fi
    fi
}

check_leaks() {
    ft_nm_output=$(cat ./valgrind.out)
    test_name=$1
    test_number=$2

    if echo "$ft_nm_output" | grep -q 'ERROR SUMMARY: 0 errors from 0 contexts'; then
        if echo "$ft_nm_output" | grep -q 'All heap blocks were freed -- no leaks are possible'; then
            echo "${_GREEN}[$test_number] ${test_name} checking leak: -> OK${_END}"
        else
            echo "${_RED}[$test_number] ${test_name}  checking leak: -> KO (memory leak)${_END}"
            if [ "$VERBOSE" -eq 1 ]; then
                echo "${_YELLOW}--- valgrind output:${_END}"
                echo "$ft_nm_output"
            fi
        fi
    else
        echo "${_RED}[$test_number] ${test_name} checking leak: -> KO (memory error)${_END}"
        if [ "$VERBOSE" -eq 1 ]; then
            echo "${_YELLOW}--- valgrind output:${_END}"
            echo "$ft_nm_output"
        fi
    fi
}

test_obj() {
    test_name="TEST OBJET"
    echo "\n\n${_YELLOW}${test_name}:${_END}"
    
    test_number=1
    sub_test_name="ft_split"
    prog=./obj/ft_split.o
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out) 
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_x32"
    prog=./obj/obj1_x32.o
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out) 
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_x64"
    prog=./obj/obj1_x64.o
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out) 
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identabi_corrupted_x64"
    prog=./obj/obj1_identabi_corrupted_x64.o
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out) 
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identclass_corrupted_x64"
    prog=./obj/obj1_identclass_corrupted_x64.o
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out)
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: Unsuported ELF file class"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identclass2_corrupted_x64"
    prog=./obj/obj1_identclass2_corrupted_x64.o
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out)
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: Unsuported ELF file class"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identclass3_x32_corrupted_x64"
    prog=./obj/obj1_identclass3_x32_corrupted_x64.o
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out)
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: fail to find symbole tab"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identdata_corrupted_x64"
    prog=./obj/obj1_identdata_corrupted_x64.o
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out)
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: Unsuported ELF file encoding"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identelf_corrupted_x64"
    prog=./obj/obj1_identelf_corrupted_x64.o
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out)
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: not ELF file"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identelf2_corrupted_x64"
    prog=./obj/obj1_identelf2_corrupted_x64.o
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out)
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: not ELF file"
    check_leaks "$sub_test_name" $test_number

    # test_number=$((test_number + 1))
    # sub_test_name="obj1_identosabi_corrupted_x64"
    # prog=./obj/obj1_identosabi_corrupted_x64.o
    # ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out)
    # compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: not ELF file"
    # check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identosabi_corrupted_x64"
    prog=./obj/obj1_identosabi_corrupted_x64.o
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out) 
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identpad_corrupted_x64"
    prog=./obj/obj1_identpad_corrupted_x64.o
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out) 
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identversion_corrupted_x64"
    prog=./obj/obj1_identversion_corrupted_x64.o
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out)
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: Unsuported ELF file version"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj2_eshoff_corrupted_x64"
    prog=./obj/obj2_eshoff_corrupted_x64.o
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out)
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: invalide section header offset"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj2_eshoff2_corrupted_x64"
    prog=./obj/obj2_eshoff2_corrupted_x64.o
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out)
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: fail to find symbole tab"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj2_eshoff3_corrupted_x64"
    prog=./obj/obj2_eshoff3_corrupted_x64.o
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out)
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: invalide section header offset"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj3_ehsize_corrupted_x64"
    prog=./obj/obj3_ehsize_corrupted_x64.o
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out) 
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj3_shentsize_corrupted_x64"
    prog=./obj/obj3_shentsize_corrupted_x64.o
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out)
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: e_shentsize is corruped or invalid"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj3_shnum2_corrupted_x64"
    prog=./obj/obj3_shnum2_corrupted_x64.o
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out)
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: fail to find symbole tab"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj4_shstrndx2_corrupted_x64"
    prog=./obj/obj4_shstrndx2_corrupted_x64.o
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out)
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: sh_name is corruped or invalid"
    check_leaks "$sub_test_name" $test_number
}

test_bin() {
    test_name="TEST BINARIE"
    echo "\n\n${_YELLOW}${test_name}:${_END}"
    
    test_number=1
    sub_test_name="absolute_value"
    prog=./bin/absolute_value
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out) 
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="absolute_value_32"
    prog=./bin/absolute_value_32
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out) 
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="bin1_x64"
    prog=./bin/bin1_x64
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out) 
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="bin2_x32"
    prog=./bin/bin2_x32
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out) 
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="easy_test"
    prog=./bin/easy_test
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out) 
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="not_so_easy_test"
    prog=./bin/not_so_easy_test
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out) 
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="error_header"
    prog=./bin/error_header
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out) 
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="header_and_prog"
    prog=./bin/header_and_prog
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: invalide section header offset"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="header"
    prog=./bin/header
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: invalide section header offset"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="header_offset_error"
    prog=./bin/header_offset_error
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out) 
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="no_symbols"
    prog=./bin/no_symbols
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: fail to find symbole tab"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="subject"
    prog=./bin/subject
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: not ELF file"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="undetermined_string"
    prog=./bin/undetermined_string
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: invalide section header offset"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="wrong_atch"
    prog=./bin/wrong_atch
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: fail to find symbole tab"
    check_leaks "$sub_test_name" $test_number
}

test_lib()
{
    test_name="TEST LIBRARIE"
    echo "\n\n${_YELLOW}${test_name}:${_END}"
    
    test_number=1
    sub_test_name="libft.so"
    prog=./lib/libft.so
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out) 
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="corrupted_e_shoff"
    prog=./lib/corrupted_e_shoff.so
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out)
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: invalide section header offset"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="corrupted_e_shoff"
    prog=./lib/corrupted_e_shoff.so
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out)
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: invalide section header offset"
    check_leaks "$sub_test_name" $test_number
    
    test_number=$((test_number + 1))
    sub_test_name="corrupted_magicNumber"
    prog=./lib/corrupted_magicNumber.so
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out)
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: not ELF file"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="corrupted_sh_name"
    prog=./lib/corrupted_sh_name.so
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out)
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: sh_name is corruped or invalid"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="corrupted_shnum"
    prog=./lib/corrupted_shnum.so
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out)
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: e_shnum is corruped or invalid"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="lib1_shname_corrupted_x64"
    prog=./lib/lib1_shname_corrupted_x64.so
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out)
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: sh_name is corruped or invalid"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="libft.a"
    prog=./lib/libft.a
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out)
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: not ELF file"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="lib1_x32.so"
    prog=./lib/lib1_x32.so
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out) 
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="lib1_x64.so"
    prog=./lib/lib1_x64.so
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out) 
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="my_simple_lib_32.so"
    prog=./lib/my_simple_lib_32.so
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out) 
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="libasan.so"
    prog=./lib/libasan.so
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out) 
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output"
    check_leaks "$sub_test_name" $test_number
}

if [ $TEST_LIB -eq 1 ] || [ $TEST_ALL -eq 1 ]
then
    test_lib
fi

if [ $TEST_BIN -eq 1 ] || [ $TEST_ALL -eq 1 ]
then
    test_bin
fi

if [ $TEST_OBJ -eq 1 ] || [ $TEST_ALL -eq 1 ]
then
    test_obj
fi

rm valgrind.out
echo
echo "nice one dude!"