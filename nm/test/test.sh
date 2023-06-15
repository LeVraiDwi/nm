#!/bin/sh

VERBOSE=1

TEST_LIB=0
TEST_BIN=0
TEST_ALL=0
TEST_BONUS=1
TEST_OBJ=0
TEST_BONUS_ALL=0
TEST_BONUS_R=0
TEST_BONUS_P=0
TEST_BONUS_RP=0
TEST_BONUS_PR=0
TEST_BONUS_A=1
TEST_BONUS_U=0
TEST_BONUS_G=0
TEST_BONUS_AU=0
TEST_BONUS_AG=0
TEST_BONUS_GU=0
TEST_BONUS_AGU=0

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
    flag=$5

    if [ "$flag" = "" ]
    then
        nm_output=$(nm "$prog" $options)
    else
        nm_output=$(nm "$flag" "$prog" $options)
    fi
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

test_Bonus() {
    if [ $TEST_BONUS_P -eq 1 ] || [ $TEST_BONUS_ALL -eq 1 ]
    then
        test_Bonus_P
    fi
    if [ $TEST_BONUS_R -eq 1 ] || [ $TEST_BONUS_ALL -eq 1 ]
    then
        test_Bonus_R
    fi
    if [ $TEST_BONUS_RP -eq 1 ] || [ $TEST_BONUS_ALL -eq 1 ]
    then
        test_Bonus_RP
    fi
    if [ $TEST_BONUS_PR -eq 1 ] || [ $TEST_BONUS_ALL -eq 1 ]
    then
        test_Bonus_PR
    fi
    if [ $TEST_BONUS_A -eq 1 ] || [ $TEST_BONUS_ALL -eq 1 ]
    then
        test_Bonus_A
    fi
    if [ $TEST_BONUS_U -eq 1 ] || [ $TEST_BONUS_ALL -eq 1 ]
    then
        test_Bonus_U
    fi
    if [ $TEST_BONUS_G -eq 1 ] || [ $TEST_BONUS_ALL -eq 1 ]
    then
        test_Bonus_G
    fi
    if [ $TEST_BONUS_AU -eq 1 ] || [ $TEST_BONUS_ALL -eq 1 ]
    then
        test_Bonus_AU
    fi
    if [ $TEST_BONUS_AG -eq 1 ] || [ $TEST_BONUS_ALL -eq 1 ]
    then
        test_Bonus_AG
    fi
    if [ $TEST_BONUS_GU -eq 1 ] || [ $TEST_BONUS_ALL -eq 1 ]
    then
        test_Bonus_GU
    fi
    if [ $TEST_BONUS_AGU -eq 1 ] || [ $TEST_BONUS_ALL -eq 1 ]
    then
        test_Bonus_AGU
    fi
}

test_Bonus_AGU() {
    test_name="FLAG AGU"
    echo "\n\n${_YELLOW}${test_name}:${_END}"

    test_number=1
    sub_test_name="ft_split"
    prog=./obj/ft_split.o
    flag="-agu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="libasan.so"
    prog=./lib/libasan.so
    flag="-agu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="arg"
    prog=./obj/arg.o
    flag="-agu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="bit_read"
    prog=./obj/bit_read.o
    flag="-agu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="check"
    prog=./obj/check.o
    flag="-agu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="display"
    prog=./obj/display.o
    flag="-agu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="elf_data_struct"
    prog=./obj/elf_data_struct.o
    flag="-agu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="elf"
    prog=./obj/elf.o
    flag="-agu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="elf_data_struct"
    prog=./obj/elf_data_struct.o
    flag="-agu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="file"
    prog=./obj/file.o
    flag="-agu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="ft_nm"
    prog=./obj/ft_nm.o
    flag="-agu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="map_struct"
    prog=./obj/map_struct.o
    flag="-agu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_x32"
    prog=./obj/obj1_x32.o
    flag="-agu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_x64"
    prog=./obj/obj1_x64.o
    flag="-agu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identabi_corrupted_x64"
    prog=./obj/obj1_identabi_corrupted_x64.o
    flag="-agu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identclass_corrupted_x64"
    prog=./obj/obj1_identclass_corrupted_x64.o
    flag="-agu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: Unsuported ELF file class"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identclass2_corrupted_x64"
    prog=./obj/obj1_identclass2_corrupted_x64.o
    flag="-agu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: Unsuported ELF file class"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identclass3_x32_corrupted_x64"
    prog=./obj/obj1_identclass3_x32_corrupted_x64.o
    flag="-agu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: fail to find symbole tab"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identdata_corrupted_x64"
    prog=./obj/obj1_identdata_corrupted_x64.o
    flag="-agu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: Unsuported ELF file encoding"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identelf_corrupted_x64"
    prog=./obj/obj1_identelf_corrupted_x64.o
    flag="-agu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: not ELF file"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identelf2_corrupted_x64"
    prog=./obj/obj1_identelf2_corrupted_x64.o
    flag="-agu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: not ELF file"
    check_leaks "$sub_test_name" $test_number

    # test_number=$((test_number + 1))
    # sub_test_name="obj1_identosabi_corrupted_x64"
    # prog=./obj/obj1_identosabi_corrupted_x64.o
    # flag="-agu"
    #ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    # compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: not ELF file"
    # check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identosabi_corrupted_x64"
    prog=./obj/obj1_identosabi_corrupted_x64.o
    flag="-agu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identpad_corrupted_x64"
    prog=./obj/obj1_identpad_corrupted_x64.o
    flag="-agu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identversion_corrupted_x64"
    prog=./obj/obj1_identversion_corrupted_x64.o
    flag="-agu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: Unsuported ELF file version"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj2_eshoff_corrupted_x64"
    prog=./obj/obj2_eshoff_corrupted_x64.o
    flag="-agu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: invalide section header offset"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj2_eshoff2_corrupted_x64"
    prog=./obj/obj2_eshoff2_corrupted_x64.o
    flag="-agu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: fail to find symbole tab"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj2_eshoff3_corrupted_x64"
    prog=./obj/obj2_eshoff3_corrupted_x64.o
    flag="-agu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: invalide section header offset"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj3_ehsize_corrupted_x64"
    prog=./obj/obj3_ehsize_corrupted_x64.o
    flag="-agu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj3_shentsize_corrupted_x64"
    prog=./obj/obj3_shentsize_corrupted_x64.o
    flag="-agu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: e_shentsize is corruped or invalid"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj3_shnum2_corrupted_x64"
    prog=./obj/obj3_shnum2_corrupted_x64.o
    flag="-agu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: fail to find symbole tab"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj4_shstrndx2_corrupted_x64"
    prog=./obj/obj4_shstrndx2_corrupted_x64.o
    flag="-agu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: fail to find string tab"
    check_leaks "$sub_test_name" $test_number
}

test_Bonus_GU() {
    test_name="FLAG GU"
    echo "\n\n${_YELLOW}${test_name}:${_END}"

    test_number=1
    sub_test_name="ft_split"
    prog=./obj/ft_split.o
    flag="-gu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="libasan.so"
    prog=./lib/libasan.so
    flag="-gu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="arg"
    prog=./obj/arg.o
    flag="-gu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="bit_read"
    prog=./obj/bit_read.o
    flag="-gu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="check"
    prog=./obj/check.o
    flag="-gu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="display"
    prog=./obj/display.o
    flag="-gu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="elf_data_struct"
    prog=./obj/elf_data_struct.o
    flag="-gu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="elf"
    prog=./obj/elf.o
    flag="-gu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="elf_data_struct"
    prog=./obj/elf_data_struct.o
    flag="-gu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="file"
    prog=./obj/file.o
    flag="-gu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="ft_nm"
    prog=./obj/ft_nm.o
    flag="-gu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="map_struct"
    prog=./obj/map_struct.o
    flag="-gu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_x32"
    prog=./obj/obj1_x32.o
    flag="-gu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_x64"
    prog=./obj/obj1_x64.o
    flag="-gu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identabi_corrupted_x64"
    prog=./obj/obj1_identabi_corrupted_x64.o
    flag="-gu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identclass_corrupted_x64"
    prog=./obj/obj1_identclass_corrupted_x64.o
    flag="-gu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: Unsuported ELF file class"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identclass2_corrupted_x64"
    prog=./obj/obj1_identclass2_corrupted_x64.o
    flag="-gu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: Unsuported ELF file class"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identclass3_x32_corrupted_x64"
    prog=./obj/obj1_identclass3_x32_corrupted_x64.o
    flag="-gu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: fail to find symbole tab"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identdata_corrupted_x64"
    prog=./obj/obj1_identdata_corrupted_x64.o
    flag="-gu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: Unsuported ELF file encoding"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identelf_corrupted_x64"
    prog=./obj/obj1_identelf_corrupted_x64.o
    flag="-gu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: not ELF file"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identelf2_corrupted_x64"
    prog=./obj/obj1_identelf2_corrupted_x64.o
    flag="-gu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: not ELF file"
    check_leaks "$sub_test_name" $test_number

    # test_number=$((test_number + 1))
    # sub_test_name="obj1_identosabi_corrupted_x64"
    # prog=./obj/obj1_identosabi_corrupted_x64.o
    # flag="-gu"
    #ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    # compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: not ELF file"
    # check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identosabi_corrupted_x64"
    prog=./obj/obj1_identosabi_corrupted_x64.o
    flag="-gu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identpad_corrupted_x64"
    prog=./obj/obj1_identpad_corrupted_x64.o
    flag="-gu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identversion_corrupted_x64"
    prog=./obj/obj1_identversion_corrupted_x64.o
    flag="-gu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: Unsuported ELF file version"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj2_eshoff_corrupted_x64"
    prog=./obj/obj2_eshoff_corrupted_x64.o
    flag="-gu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: invalide section header offset"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj2_eshoff2_corrupted_x64"
    prog=./obj/obj2_eshoff2_corrupted_x64.o
    flag="-gu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: fail to find symbole tab"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj2_eshoff3_corrupted_x64"
    prog=./obj/obj2_eshoff3_corrupted_x64.o
    flag="-gu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: invalide section header offset"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj3_ehsize_corrupted_x64"
    prog=./obj/obj3_ehsize_corrupted_x64.o
    flag="-gu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj3_shentsize_corrupted_x64"
    prog=./obj/obj3_shentsize_corrupted_x64.o
    flag="-gu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: e_shentsize is corruped or invalid"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj3_shnum2_corrupted_x64"
    prog=./obj/obj3_shnum2_corrupted_x64.o
    flag="-gu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: fail to find symbole tab"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj4_shstrndx2_corrupted_x64"
    prog=./obj/obj4_shstrndx2_corrupted_x64.o
    flag="-gu"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: fail to find string tab"
    check_leaks "$sub_test_name" $test_number
}

test_Bonus_AG() {
    test_name="FLAG AG"
    echo "\n\n${_YELLOW}${test_name}:${_END}"

    test_number=1
    sub_test_name="ft_split"
    prog=./obj/ft_split.o
    flag="-ag"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="libasan.so"
    prog=./lib/libasan.so
    flag="-ag"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="arg"
    prog=./obj/arg.o
    flag="-ag"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="bit_read"
    prog=./obj/bit_read.o
    flag="-ag"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="check"
    prog=./obj/check.o
    flag="-ag"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="display"
    prog=./obj/display.o
    flag="-ag"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="elf_data_struct"
    prog=./obj/elf_data_struct.o
    flag="-ag"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="elf"
    prog=./obj/elf.o
    flag="-ag"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="elf_data_struct"
    prog=./obj/elf_data_struct.o
    flag="-ag"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="file"
    prog=./obj/file.o
    flag="-ag"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="ft_nm"
    prog=./obj/ft_nm.o
    flag="-ag"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="map_struct"
    prog=./obj/map_struct.o
    flag="-ag"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_x32"
    prog=./obj/obj1_x32.o
    flag="-ag"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_x64"
    prog=./obj/obj1_x64.o
    flag="-ag"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identabi_corrupted_x64"
    prog=./obj/obj1_identabi_corrupted_x64.o
    flag="-ag"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identclass_corrupted_x64"
    prog=./obj/obj1_identclass_corrupted_x64.o
    flag="-ag"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: Unsuported ELF file class"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identclass2_corrupted_x64"
    prog=./obj/obj1_identclass2_corrupted_x64.o
    flag="-ag"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: Unsuported ELF file class"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identclass3_x32_corrupted_x64"
    prog=./obj/obj1_identclass3_x32_corrupted_x64.o
    flag="-ag"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: fail to find symbole tab"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identdata_corrupted_x64"
    prog=./obj/obj1_identdata_corrupted_x64.o
    flag="-ag"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: Unsuported ELF file encoding"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identelf_corrupted_x64"
    prog=./obj/obj1_identelf_corrupted_x64.o
    flag="-ag"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: not ELF file"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identelf2_corrupted_x64"
    prog=./obj/obj1_identelf2_corrupted_x64.o
    flag="-ag"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: not ELF file"
    check_leaks "$sub_test_name" $test_number

    # test_number=$((test_number + 1))
    # sub_test_name="obj1_identosabi_corrupted_x64"
    # prog=./obj/obj1_identosabi_corrupted_x64.o
    # flag="-ag"
    #ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    # compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: not ELF file"
    # check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identosabi_corrupted_x64"
    prog=./obj/obj1_identosabi_corrupted_x64.o
    flag="-ag"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identpad_corrupted_x64"
    prog=./obj/obj1_identpad_corrupted_x64.o
    flag="-ag"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identversion_corrupted_x64"
    prog=./obj/obj1_identversion_corrupted_x64.o
    flag="-ag"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: Unsuported ELF file version"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj2_eshoff_corrupted_x64"
    prog=./obj/obj2_eshoff_corrupted_x64.o
    flag="-ag"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: invalide section header offset"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj2_eshoff2_corrupted_x64"
    prog=./obj/obj2_eshoff2_corrupted_x64.o
    flag="-ag"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: fail to find symbole tab"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj2_eshoff3_corrupted_x64"
    prog=./obj/obj2_eshoff3_corrupted_x64.o
    flag="-ag"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: invalide section header offset"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj3_ehsize_corrupted_x64"
    prog=./obj/obj3_ehsize_corrupted_x64.o
    flag="-ag"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj3_shentsize_corrupted_x64"
    prog=./obj/obj3_shentsize_corrupted_x64.o
    flag="-ag"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: e_shentsize is corruped or invalid"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj3_shnum2_corrupted_x64"
    prog=./obj/obj3_shnum2_corrupted_x64.o
    flag="-ag"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: fail to find symbole tab"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj4_shstrndx2_corrupted_x64"
    prog=./obj/obj4_shstrndx2_corrupted_x64.o
    flag="-ag"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: fail to find string tab"
    check_leaks "$sub_test_name" $test_number
}

test_Bonus_AU() {
    test_name="FLAG AU"
    echo "\n\n${_YELLOW}${test_name}:${_END}"

    test_number=1
    sub_test_name="ft_split"
    prog=./obj/ft_split.o
    flag="-au"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="libasan.so"
    prog=./lib/libasan.so
    flag="-au"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="arg"
    prog=./obj/arg.o
    flag="-au"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="bit_read"
    prog=./obj/bit_read.o
    flag="-au"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="check"
    prog=./obj/check.o
    flag="-au"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="display"
    prog=./obj/display.o
    flag="-au"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="elf_data_struct"
    prog=./obj/elf_data_struct.o
    flag="-au"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="elf"
    prog=./obj/elf.o
    flag="-au"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="elf_data_struct"
    prog=./obj/elf_data_struct.o
    flag="-au"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="file"
    prog=./obj/file.o
    flag="-au"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="ft_nm"
    prog=./obj/ft_nm.o
    flag="-au"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="map_struct"
    prog=./obj/map_struct.o
    flag="-au"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_x32"
    prog=./obj/obj1_x32.o
    flag="-au"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_x64"
    prog=./obj/obj1_x64.o
    flag="-au"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identabi_corrupted_x64"
    prog=./obj/obj1_identabi_corrupted_x64.o
    flag="-au"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identclass_corrupted_x64"
    prog=./obj/obj1_identclass_corrupted_x64.o
    flag="-au"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: Unsuported ELF file class"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identclass2_corrupted_x64"
    prog=./obj/obj1_identclass2_corrupted_x64.o
    flag="-au"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: Unsuported ELF file class"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identclass3_x32_corrupted_x64"
    prog=./obj/obj1_identclass3_x32_corrupted_x64.o
    flag="-au"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: fail to find symbole tab"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identdata_corrupted_x64"
    prog=./obj/obj1_identdata_corrupted_x64.o
    flag="-au"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: Unsuported ELF file encoding"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identelf_corrupted_x64"
    prog=./obj/obj1_identelf_corrupted_x64.o
    flag="-au"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: not ELF file"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identelf2_corrupted_x64"
    prog=./obj/obj1_identelf2_corrupted_x64.o
    flag="-au"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: not ELF file"
    check_leaks "$sub_test_name" $test_number

    # test_number=$((test_number + 1))
    # sub_test_name="obj1_identosabi_corrupted_x64"
    # prog=./obj/obj1_identosabi_corrupted_x64.o
    # flag="-au"
    #ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    # compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: not ELF file"
    # check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identosabi_corrupted_x64"
    prog=./obj/obj1_identosabi_corrupted_x64.o
    flag="-au"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identpad_corrupted_x64"
    prog=./obj/obj1_identpad_corrupted_x64.o
    flag="-au"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identversion_corrupted_x64"
    prog=./obj/obj1_identversion_corrupted_x64.o
    flag="-au"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: Unsuported ELF file version"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj2_eshoff_corrupted_x64"
    prog=./obj/obj2_eshoff_corrupted_x64.o
    flag="-au"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: invalide section header offset"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj2_eshoff2_corrupted_x64"
    prog=./obj/obj2_eshoff2_corrupted_x64.o
    flag="-au"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: fail to find symbole tab"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj2_eshoff3_corrupted_x64"
    prog=./obj/obj2_eshoff3_corrupted_x64.o
    flag="-au"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: invalide section header offset"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj3_ehsize_corrupted_x64"
    prog=./obj/obj3_ehsize_corrupted_x64.o
    flag="-au"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj3_shentsize_corrupted_x64"
    prog=./obj/obj3_shentsize_corrupted_x64.o
    flag="-au"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: e_shentsize is corruped or invalid"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj3_shnum2_corrupted_x64"
    prog=./obj/obj3_shnum2_corrupted_x64.o
    flag="-au"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: fail to find symbole tab"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj4_shstrndx2_corrupted_x64"
    prog=./obj/obj4_shstrndx2_corrupted_x64.o
    flag="-au"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: fail to find string tab"
    check_leaks "$sub_test_name" $test_number
}

test_Bonus_U() {
    test_name="FLAG U"
    echo "\n\n${_YELLOW}${test_name}:${_END}"

    test_number=1
    sub_test_name="ft_split"
    prog=./obj/ft_split.o
    flag="-u"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="libasan.so"
    prog=./lib/libasan.so
    flag="-u"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="arg"
    prog=./obj/arg.o
    flag="-u"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="bit_read"
    prog=./obj/bit_read.o
    flag="-u"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="check"
    prog=./obj/check.o
    flag="-u"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="display"
    prog=./obj/display.o
    flag="-u"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="elf_data_struct"
    prog=./obj/elf_data_struct.o
    flag="-u"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="elf"
    prog=./obj/elf.o
    flag="-u"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="elf_data_struct"
    prog=./obj/elf_data_struct.o
    flag="-u"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="file"
    prog=./obj/file.o
    flag="-u"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="ft_nm"
    prog=./obj/ft_nm.o
    flag="-u"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="map_struct"
    prog=./obj/map_struct.o
    flag="-u"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_x32"
    prog=./obj/obj1_x32.o
    flag="-u"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_x64"
    prog=./obj/obj1_x64.o
    flag="-u"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identabi_corrupted_x64"
    prog=./obj/obj1_identabi_corrupted_x64.o
    flag="-u"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identclass_corrupted_x64"
    prog=./obj/obj1_identclass_corrupted_x64.o
    flag="-u"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: Unsuported ELF file class"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identclass2_corrupted_x64"
    prog=./obj/obj1_identclass2_corrupted_x64.o
    flag="-u"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: Unsuported ELF file class"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identclass3_x32_corrupted_x64"
    prog=./obj/obj1_identclass3_x32_corrupted_x64.o
    flag="-u"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: fail to find symbole tab"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identdata_corrupted_x64"
    prog=./obj/obj1_identdata_corrupted_x64.o
    flag="-u"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: Unsuported ELF file encoding"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identelf_corrupted_x64"
    prog=./obj/obj1_identelf_corrupted_x64.o
    flag="-u"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: not ELF file"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identelf2_corrupted_x64"
    prog=./obj/obj1_identelf2_corrupted_x64.o
    flag="-u"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: not ELF file"
    check_leaks "$sub_test_name" $test_number

    # test_number=$((test_number + 1))
    # sub_test_name="obj1_identosabi_corrupted_x64"
    # prog=./obj/obj1_identosabi_corrupted_x64.o
    # flag="-u"
    #ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    # compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: not ELF file"
    # check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identosabi_corrupted_x64"
    prog=./obj/obj1_identosabi_corrupted_x64.o
    flag="-u"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identpad_corrupted_x64"
    prog=./obj/obj1_identpad_corrupted_x64.o
    flag="-u"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identversion_corrupted_x64"
    prog=./obj/obj1_identversion_corrupted_x64.o
    flag="-u"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: Unsuported ELF file version"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj2_eshoff_corrupted_x64"
    prog=./obj/obj2_eshoff_corrupted_x64.o
    flag="-u"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: invalide section header offset"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj2_eshoff2_corrupted_x64"
    prog=./obj/obj2_eshoff2_corrupted_x64.o
    flag="-u"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: fail to find symbole tab"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj2_eshoff3_corrupted_x64"
    prog=./obj/obj2_eshoff3_corrupted_x64.o
    flag="-u"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: invalide section header offset"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj3_ehsize_corrupted_x64"
    prog=./obj/obj3_ehsize_corrupted_x64.o
    flag="-u"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj3_shentsize_corrupted_x64"
    prog=./obj/obj3_shentsize_corrupted_x64.o
    flag="-u"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: e_shentsize is corruped or invalid"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj3_shnum2_corrupted_x64"
    prog=./obj/obj3_shnum2_corrupted_x64.o
    flag="-u"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: fail to find symbole tab"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj4_shstrndx2_corrupted_x64"
    prog=./obj/obj4_shstrndx2_corrupted_x64.o
    flag="-u"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: fail to find string tab"
    check_leaks "$sub_test_name" $test_number
}

test_Bonus_G() {
    test_name="FLAG G"
    echo "\n\n${_YELLOW}${test_name}:${_END}"

    test_number=1
    sub_test_name="ft_split"
    prog=./obj/ft_split.o
    flag="-g"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="libasan.so"
    prog=./lib/libasan.so
    flag="-g"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="arg"
    prog=./obj/arg.o
    flag="-g"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="bit_read"
    prog=./obj/bit_read.o
    flag="-g"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="check"
    prog=./obj/check.o
    flag="-g"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="display"
    prog=./obj/display.o
    flag="-g"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="elf_data_struct"
    prog=./obj/elf_data_struct.o
    flag="-g"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="elf"
    prog=./obj/elf.o
    flag="-g"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="elf_data_struct"
    prog=./obj/elf_data_struct.o
    flag="-g"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="file"
    prog=./obj/file.o
    flag="-g"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="ft_nm"
    prog=./obj/ft_nm.o
    flag="-g"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="map_struct"
    prog=./obj/map_struct.o
    flag="-g"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_x32"
    prog=./obj/obj1_x32.o
    flag="-g"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_x64"
    prog=./obj/obj1_x64.o
    flag="-g"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identabi_corrupted_x64"
    prog=./obj/obj1_identabi_corrupted_x64.o
    flag="-g"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identclass_corrupted_x64"
    prog=./obj/obj1_identclass_corrupted_x64.o
    flag="-g"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: Unsuported ELF file class"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identclass2_corrupted_x64"
    prog=./obj/obj1_identclass2_corrupted_x64.o
    flag="-g"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: Unsuported ELF file class"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identclass3_x32_corrupted_x64"
    prog=./obj/obj1_identclass3_x32_corrupted_x64.o
    flag="-g"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: fail to find symbole tab"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identdata_corrupted_x64"
    prog=./obj/obj1_identdata_corrupted_x64.o
    flag="-g"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: Unsuported ELF file encoding"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identelf_corrupted_x64"
    prog=./obj/obj1_identelf_corrupted_x64.o
    flag="-g"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: not ELF file"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identelf2_corrupted_x64"
    prog=./obj/obj1_identelf2_corrupted_x64.o
    flag="-g"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: not ELF file"
    check_leaks "$sub_test_name" $test_number

    # test_number=$((test_number + 1))
    # sub_test_name="obj1_identosabi_corrupted_x64"
    # prog=./obj/obj1_identosabi_corrupted_x64.o
    # flag="-g"
    #ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    # compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: not ELF file"
    # check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identosabi_corrupted_x64"
    prog=./obj/obj1_identosabi_corrupted_x64.o
    flag="-g"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identpad_corrupted_x64"
    prog=./obj/obj1_identpad_corrupted_x64.o
    flag="-g"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identversion_corrupted_x64"
    prog=./obj/obj1_identversion_corrupted_x64.o
    flag="-g"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: Unsuported ELF file version"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj2_eshoff_corrupted_x64"
    prog=./obj/obj2_eshoff_corrupted_x64.o
    flag="-g"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: invalide section header offset"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj2_eshoff2_corrupted_x64"
    prog=./obj/obj2_eshoff2_corrupted_x64.o
    flag="-g"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: fail to find symbole tab"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj2_eshoff3_corrupted_x64"
    prog=./obj/obj2_eshoff3_corrupted_x64.o
    flag="-g"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: invalide section header offset"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj3_ehsize_corrupted_x64"
    prog=./obj/obj3_ehsize_corrupted_x64.o
    flag="-g"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj3_shentsize_corrupted_x64"
    prog=./obj/obj3_shentsize_corrupted_x64.o
    flag="-g"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: e_shentsize is corruped or invalid"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj3_shnum2_corrupted_x64"
    prog=./obj/obj3_shnum2_corrupted_x64.o
    flag="-g"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: fail to find symbole tab"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj4_shstrndx2_corrupted_x64"
    prog=./obj/obj4_shstrndx2_corrupted_x64.o
    flag="-g"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: fail to find string tab"
    check_leaks "$sub_test_name" $test_number
}

test_Bonus_A() {
    test_name="FLAG A"
    echo "\n\n${_YELLOW}${test_name}:${_END}"

    test_number=1
    sub_test_name="ft_split"
    prog=./obj/ft_split.o
    flag="-a"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="libasan.so"
    prog=./lib/libasan.so
    flag="-a"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="arg"
    prog=./obj/arg.o
    flag="-a"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="bit_read"
    prog=./obj/bit_read.o
    flag="-a"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="check"
    prog=./obj/check.o
    flag="-a"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="display"
    prog=./obj/display.o
    flag="-a"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="elf_data_struct"
    prog=./obj/elf_data_struct.o
    flag="-a"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="elf"
    prog=./obj/elf.o
    flag="-a"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="elf_data_struct"
    prog=./obj/elf_data_struct.o
    flag="-a"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="file"
    prog=./obj/file.o
    flag="-a"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="ft_nm"
    prog=./obj/ft_nm.o
    flag="-a"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="map_struct"
    prog=./obj/map_struct.o
    flag="-a"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_x32"
    prog=./obj/obj1_x32.o
    flag="-a"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_x64"
    prog=./obj/obj1_x64.o
    flag="-a"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identabi_corrupted_x64"
    prog=./obj/obj1_identabi_corrupted_x64.o
    flag="-a"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identclass_corrupted_x64"
    prog=./obj/obj1_identclass_corrupted_x64.o
    flag="-a"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: Unsuported ELF file class"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identclass2_corrupted_x64"
    prog=./obj/obj1_identclass2_corrupted_x64.o
    flag="-a"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: Unsuported ELF file class"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identclass3_x32_corrupted_x64"
    prog=./obj/obj1_identclass3_x32_corrupted_x64.o
    flag="-a"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: fail to find symbole tab"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identdata_corrupted_x64"
    prog=./obj/obj1_identdata_corrupted_x64.o
    flag="-a"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: Unsuported ELF file encoding"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identelf_corrupted_x64"
    prog=./obj/obj1_identelf_corrupted_x64.o
    flag="-a"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: not ELF file"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identelf2_corrupted_x64"
    prog=./obj/obj1_identelf2_corrupted_x64.o
    flag="-a"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: not ELF file"
    check_leaks "$sub_test_name" $test_number

    # test_number=$((test_number + 1))
    # sub_test_name="obj1_identosabi_corrupted_x64"
    # prog=./obj/obj1_identosabi_corrupted_x64.o
    # flag="-a"
    #ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    # compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: not ELF file"
    # check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identosabi_corrupted_x64"
    prog=./obj/obj1_identosabi_corrupted_x64.o
    flag="-a"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identpad_corrupted_x64"
    prog=./obj/obj1_identpad_corrupted_x64.o
    flag="-a"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identversion_corrupted_x64"
    prog=./obj/obj1_identversion_corrupted_x64.o
    flag="-a"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: Unsuported ELF file version"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj2_eshoff_corrupted_x64"
    prog=./obj/obj2_eshoff_corrupted_x64.o
    flag="-a"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: invalide section header offset"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj2_eshoff2_corrupted_x64"
    prog=./obj/obj2_eshoff2_corrupted_x64.o
    flag="-a"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: fail to find symbole tab"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj2_eshoff3_corrupted_x64"
    prog=./obj/obj2_eshoff3_corrupted_x64.o
    flag="-a"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: invalide section header offset"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj3_ehsize_corrupted_x64"
    prog=./obj/obj3_ehsize_corrupted_x64.o
    flag="-a"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj3_shentsize_corrupted_x64"
    prog=./obj/obj3_shentsize_corrupted_x64.o
    flag="-a"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: e_shentsize is corruped or invalid"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj3_shnum2_corrupted_x64"
    prog=./obj/obj3_shnum2_corrupted_x64.o
    flag="-a"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: fail to find symbole tab"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj4_shstrndx2_corrupted_x64"
    prog=./obj/obj4_shstrndx2_corrupted_x64.o
    flag="-a"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: fail to find string tab"
    check_leaks "$sub_test_name" $test_number
}

test_Bonus_PR() {
    test_name="FLAG PR"
    echo "\n\n${_YELLOW}${test_name}:${_END}"

    test_number=1
    sub_test_name="ft_split"
    prog=./obj/ft_split.o
    flag="-pr"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="libasan.so"
    prog=./lib/libasan.so
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out) 
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="arg"
    prog=./obj/arg.o
    flag="-pr"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="bit_read"
    prog=./obj/bit_read.o
    flag="-pr"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="check"
    prog=./obj/check.o
    flag="-pr"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="display"
    prog=./obj/display.o
    flag="-pr"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="elf_data_struct"
    prog=./obj/elf_data_struct.o
    flag="-pr"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="elf"
    prog=./obj/elf.o
    flag="-pr"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="elf_data_struct"
    prog=./obj/elf_data_struct.o
    flag="-pr"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="file"
    prog=./obj/file.o
    flag="-pr"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="ft_nm"
    prog=./obj/ft_nm.o
    flag="-pr"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="map_struct"
    prog=./obj/map_struct.o
    flag="-pr"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_x32"
    prog=./obj/obj1_x32.o
    flag="-pr"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_x64"
    prog=./obj/obj1_x64.o
    flag="-pr"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identabi_corrupted_x64"
    prog=./obj/obj1_identabi_corrupted_x64.o
    flag="-pr"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identclass_corrupted_x64"
    prog=./obj/obj1_identclass_corrupted_x64.o
    flag="-pr"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: Unsuported ELF file class"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identclass2_corrupted_x64"
    prog=./obj/obj1_identclass2_corrupted_x64.o
    flag="-pr"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: Unsuported ELF file class"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identclass3_x32_corrupted_x64"
    prog=./obj/obj1_identclass3_x32_corrupted_x64.o
    flag="-pr"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: fail to find symbole tab"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identdata_corrupted_x64"
    prog=./obj/obj1_identdata_corrupted_x64.o
    flag="-pr"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: Unsuported ELF file encoding"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identelf_corrupted_x64"
    prog=./obj/obj1_identelf_corrupted_x64.o
    flag="-pr"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: not ELF file"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identelf2_corrupted_x64"
    prog=./obj/obj1_identelf2_corrupted_x64.o
    flag="-pr"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: not ELF file"
    check_leaks "$sub_test_name" $test_number

    # test_number=$((test_number + 1))
    # sub_test_name="obj1_identosabi_corrupted_x64"
    # prog=./obj/obj1_identosabi_corrupted_x64.o
    # flag="-pr"
    #ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    # compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: not ELF file"
    # check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identosabi_corrupted_x64"
    prog=./obj/obj1_identosabi_corrupted_x64.o
    flag="-pr"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identpad_corrupted_x64"
    prog=./obj/obj1_identpad_corrupted_x64.o
    flag="-pr"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identversion_corrupted_x64"
    prog=./obj/obj1_identversion_corrupted_x64.o
    flag="-pr"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: Unsuported ELF file version"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj2_eshoff_corrupted_x64"
    prog=./obj/obj2_eshoff_corrupted_x64.o
    flag="-pr"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: invalide section header offset"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj2_eshoff2_corrupted_x64"
    prog=./obj/obj2_eshoff2_corrupted_x64.o
    flag="-pr"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: fail to find symbole tab"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj2_eshoff3_corrupted_x64"
    prog=./obj/obj2_eshoff3_corrupted_x64.o
    flag="-pr"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: invalide section header offset"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj3_ehsize_corrupted_x64"
    prog=./obj/obj3_ehsize_corrupted_x64.o
    flag="-pr"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj3_shentsize_corrupted_x64"
    prog=./obj/obj3_shentsize_corrupted_x64.o
    flag="-pr"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: e_shentsize is corruped or invalid"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj3_shnum2_corrupted_x64"
    prog=./obj/obj3_shnum2_corrupted_x64.o
    flag="-pr"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: fail to find symbole tab"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj4_shstrndx2_corrupted_x64"
    prog=./obj/obj4_shstrndx2_corrupted_x64.o
    flag="-pr"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: fail to find string tab"
    check_leaks "$sub_test_name" $test_number
}

test_Bonus_RP() {
    test_name="FLAG RP"
    echo "\n\n${_YELLOW}${test_name}:${_END}"

    test_number=1
    sub_test_name="ft_split"
    prog=./obj/ft_split.o
    flag="-rp"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="libasan.so"
    prog=./lib/libasan.so
    flag="-rp"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="arg"
    prog=./obj/arg.o
    flag="-rp"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="bit_read"
    prog=./obj/bit_read.o
    flag="-rp"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="check"
    prog=./obj/check.o
    flag="-rp"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="display"
    prog=./obj/display.o
    flag="-rp"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="elf_data_struct"
    prog=./obj/elf_data_struct.o
    flag="-rp"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="elf"
    prog=./obj/elf.o
    flag="-rp"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="elf_data_struct"
    prog=./obj/elf_data_struct.o
    flag="-rp"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="file"
    prog=./obj/file.o
    flag="-rp"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="ft_nm"
    prog=./obj/ft_nm.o
    flag="-rp"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="map_struct"
    prog=./obj/map_struct.o
    flag="-rp"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_x32"
    prog=./obj/obj1_x32.o
    flag="-rp"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_x64"
    prog=./obj/obj1_x64.o
    flag="-rp"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identabi_corrupted_x64"
    prog=./obj/obj1_identabi_corrupted_x64.o
    flag="-rp"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identclass_corrupted_x64"
    prog=./obj/obj1_identclass_corrupted_x64.o
    flag="-rp"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: Unsuported ELF file class"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identclass2_corrupted_x64"
    prog=./obj/obj1_identclass2_corrupted_x64.o
    flag="-rp"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: Unsuported ELF file class"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identclass3_x32_corrupted_x64"
    prog=./obj/obj1_identclass3_x32_corrupted_x64.o
    flag="-rp"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: fail to find symbole tab"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identdata_corrupted_x64"
    prog=./obj/obj1_identdata_corrupted_x64.o
    flag="-rp"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: Unsuported ELF file encoding"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identelf_corrupted_x64"
    prog=./obj/obj1_identelf_corrupted_x64.o
    flag="-rp"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: not ELF file"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identelf2_corrupted_x64"
    prog=./obj/obj1_identelf2_corrupted_x64.o
    flag="-rp"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: not ELF file"
    check_leaks "$sub_test_name" $test_number

    # test_number=$((test_number + 1))
    # sub_test_name="obj1_identosabi_corrupted_x64"
    # prog=./obj/obj1_identosabi_corrupted_x64.o
    # flag="-rp"
    #ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    # compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: not ELF file"
    # check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identosabi_corrupted_x64"
    prog=./obj/obj1_identosabi_corrupted_x64.o
    flag="-rp"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identpad_corrupted_x64"
    prog=./obj/obj1_identpad_corrupted_x64.o
    flag="-rp"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identversion_corrupted_x64"
    prog=./obj/obj1_identversion_corrupted_x64.o
    flag="-rp"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: Unsuported ELF file version"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj2_eshoff_corrupted_x64"
    prog=./obj/obj2_eshoff_corrupted_x64.o
    flag="-rp"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: invalide section header offset"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj2_eshoff2_corrupted_x64"
    prog=./obj/obj2_eshoff2_corrupted_x64.o
    flag="-rp"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: fail to find symbole tab"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj2_eshoff3_corrupted_x64"
    prog=./obj/obj2_eshoff3_corrupted_x64.o
    flag="-rp"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: invalide section header offset"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj3_ehsize_corrupted_x64"
    prog=./obj/obj3_ehsize_corrupted_x64.o
    flag="-rp"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj3_shentsize_corrupted_x64"
    prog=./obj/obj3_shentsize_corrupted_x64.o
    flag="-rp"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: e_shentsize is corruped or invalid"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj3_shnum2_corrupted_x64"
    prog=./obj/obj3_shnum2_corrupted_x64.o
    flag="-rp"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: fail to find symbole tab"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj4_shstrndx2_corrupted_x64"
    prog=./obj/obj4_shstrndx2_corrupted_x64.o
    flag="-rp"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: fail to find string tab"
    check_leaks "$sub_test_name" $test_number
}

test_Bonus_R() {
    test_name="FLAG R"
    echo "\n\n${_YELLOW}${test_name}:${_END}"

    test_number=1
    sub_test_name="ft_split"
    prog=./obj/ft_split.o
    flag="-r"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="libasan.so"
    prog=./lib/libasan.so
    flag="-r"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="arg"
    prog=./obj/arg.o
    flag="-r"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="bit_read"
    prog=./obj/bit_read.o
    flag="-r"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="check"
    prog=./obj/check.o
    flag="-r"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="display"
    prog=./obj/display.o
    flag="-r"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="elf_data_struct"
    prog=./obj/elf_data_struct.o
    flag="-r"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="elf"
    prog=./obj/elf.o
    flag="-r"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="elf_data_struct"
    prog=./obj/elf_data_struct.o
    flag="-r"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="file"
    prog=./obj/file.o
    flag="-r"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="ft_nm"
    prog=./obj/ft_nm.o
    flag="-r"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="map_struct"
    prog=./obj/map_struct.o
    flag="-r"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_x32"
    prog=./obj/obj1_x32.o
    flag="-r"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_x64"
    prog=./obj/obj1_x64.o
    flag="-r"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identabi_corrupted_x64"
    prog=./obj/obj1_identabi_corrupted_x64.o
    flag="-r"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identclass_corrupted_x64"
    prog=./obj/obj1_identclass_corrupted_x64.o
    flag="-r"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: Unsuported ELF file class"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identclass2_corrupted_x64"
    prog=./obj/obj1_identclass2_corrupted_x64.o
    flag="-r"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: Unsuported ELF file class"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identclass3_x32_corrupted_x64"
    prog=./obj/obj1_identclass3_x32_corrupted_x64.o
    flag="-r"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: fail to find symbole tab"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identdata_corrupted_x64"
    prog=./obj/obj1_identdata_corrupted_x64.o
    flag="-r"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: Unsuported ELF file encoding"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identelf_corrupted_x64"
    prog=./obj/obj1_identelf_corrupted_x64.o
    flag="-r"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: not ELF file"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identelf2_corrupted_x64"
    prog=./obj/obj1_identelf2_corrupted_x64.o
    flag="-r"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: not ELF file"
    check_leaks "$sub_test_name" $test_number

    # test_number=$((test_number + 1))
    # sub_test_name="obj1_identosabi_corrupted_x64"
    # prog=./obj/obj1_identosabi_corrupted_x64.o
    # flag="-r"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    # compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: not ELF file"
    # check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identosabi_corrupted_x64"
    prog=./obj/obj1_identosabi_corrupted_x64.o
    flag="-r"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identpad_corrupted_x64"
    prog=./obj/obj1_identpad_corrupted_x64.o
    flag="-r"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identversion_corrupted_x64"
    prog=./obj/obj1_identversion_corrupted_x64.o
    flag="-r"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: Unsuported ELF file version"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj2_eshoff_corrupted_x64"
    prog=./obj/obj2_eshoff_corrupted_x64.o
    flag="-r"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: invalide section header offset"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj2_eshoff2_corrupted_x64"
    prog=./obj/obj2_eshoff2_corrupted_x64.o
    flag="-r"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: fail to find symbole tab"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj2_eshoff3_corrupted_x64"
    prog=./obj/obj2_eshoff3_corrupted_x64.o
    flag="-r"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: invalide section header offset"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj3_ehsize_corrupted_x64"
    prog=./obj/obj3_ehsize_corrupted_x64.o
    flag="-r"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj3_shentsize_corrupted_x64"
    prog=./obj/obj3_shentsize_corrupted_x64.o
    flag="-r"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: e_shentsize is corruped or invalid"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj3_shnum2_corrupted_x64"
    prog=./obj/obj3_shnum2_corrupted_x64.o
    flag="-r"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: fail to find symbole tab"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj4_shstrndx2_corrupted_x64"
    prog=./obj/obj4_shstrndx2_corrupted_x64.o
    flag="-r"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: fail to find string tab"
    check_leaks "$sub_test_name" $test_number
}

test_Bonus_P() {
    test_name="FLAG P"
    echo "\n\n${_YELLOW}${test_name}:${_END}"

    test_number=1
    sub_test_name="ft_split"
    prog=./obj/ft_split.o
    flag="-p"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="libasan.so"
    prog=./lib/libasan.so
    flag="-p"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="arg"
    prog=./obj/arg.o
    flag="-p"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="bit_read"
    prog=./obj/bit_read.o
    flag="-p"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="check"
    prog=./obj/check.o
    flag="-p"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="display"
    prog=./obj/display.o
    flag="-p"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="elf_data_struct"
    prog=./obj/elf_data_struct.o
    flag="-p"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="elf"
    prog=./obj/elf.o
    flag="-p"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="elf_data_struct"
    prog=./obj/elf_data_struct.o
    flag="-p"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="file"
    prog=./obj/file.o
    flag="-p"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="ft_nm"
    prog=./obj/ft_nm.o
    flag="-p"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="map_struct"
    prog=./obj/map_struct.o
    flag="-p"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_x32"
    prog=./obj/obj1_x32.o
    flag="-p"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_x64"
    prog=./obj/obj1_x64.o
    flag="-p"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identabi_corrupted_x64"
    prog=./obj/obj1_identabi_corrupted_x64.o
    flag="-p"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identclass_corrupted_x64"
    prog=./obj/obj1_identclass_corrupted_x64.o
    flag="-p"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: Unsuported ELF file class"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identclass2_corrupted_x64"
    prog=./obj/obj1_identclass2_corrupted_x64.o
    flag="-p"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: Unsuported ELF file class"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identclass3_x32_corrupted_x64"
    prog=./obj/obj1_identclass3_x32_corrupted_x64.o
    flag="-p"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: fail to find symbole tab"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identdata_corrupted_x64"
    prog=./obj/obj1_identdata_corrupted_x64.o
    flag="-p"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: Unsuported ELF file encoding"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identelf_corrupted_x64"
    prog=./obj/obj1_identelf_corrupted_x64.o
    flag="-p"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: not ELF file"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identelf2_corrupted_x64"
    prog=./obj/obj1_identelf2_corrupted_x64.o
    flag="-p"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: not ELF file"
    check_leaks "$sub_test_name" $test_number

    # test_number=$((test_number + 1))
    # sub_test_name="obj1_identosabi_corrupted_x64"
    # prog=./obj/obj1_identosabi_corrupted_x64.o
    # flag="-p"
    #ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    # compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: not ELF file"
    # check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identosabi_corrupted_x64"
    prog=./obj/obj1_identosabi_corrupted_x64.o
    flag="-p"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identpad_corrupted_x64"
    prog=./obj/obj1_identpad_corrupted_x64.o
    flag="-p"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj1_identversion_corrupted_x64"
    prog=./obj/obj1_identversion_corrupted_x64.o
    flag="-p"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: Unsuported ELF file version"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj2_eshoff_corrupted_x64"
    prog=./obj/obj2_eshoff_corrupted_x64.o
    flag="-p"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: invalide section header offset"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj2_eshoff2_corrupted_x64"
    prog=./obj/obj2_eshoff2_corrupted_x64.o
    flag="-p"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: fail to find symbole tab"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj2_eshoff3_corrupted_x64"
    prog=./obj/obj2_eshoff3_corrupted_x64.o
    flag="-p"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: invalide section header offset"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj3_ehsize_corrupted_x64"
    prog=./obj/obj3_ehsize_corrupted_x64.o
    flag="-p"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out)  
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output" "$flag"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj3_shentsize_corrupted_x64"
    prog=./obj/obj3_shentsize_corrupted_x64.o
    flag="-p"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: e_shentsize is corruped or invalid"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj3_shnum2_corrupted_x64"
    prog=./obj/obj3_shnum2_corrupted_x64.o
    flag="-p"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: fail to find symbole tab"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="obj4_shstrndx2_corrupted_x64"
    prog=./obj/obj4_shstrndx2_corrupted_x64.o
    flag="-p"
    ft_nm_output=$(valgrind ../ft_nm $flag $prog 2>./valgrind.out) 
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: fail to find string tab"
    check_leaks "$sub_test_name" $test_number
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
    sub_test_name="arg"
    prog=./obj/arg.o
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out) 
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="bit_read"
    prog=./obj/bit_read.o
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out) 
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="check"
    prog=./obj/check.o
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out) 
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="display"
    prog=./obj/display.o
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out) 
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="elf_data_struct"
    prog=./obj/elf_data_struct.o
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out) 
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="elf"
    prog=./obj/elf.o
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out) 
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="elf_data_struct"
    prog=./obj/elf_data_struct.o
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out) 
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="file"
    prog=./obj/file.o
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out) 
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="ft_nm"
    prog=./obj/ft_nm.o
    ft_nm_output=$(valgrind ../ft_nm $prog 2>./valgrind.out) 
    compare_nm_and_ft_nm_output "$sub_test_name" $test_number "$prog" "$ft_nm_output"
    check_leaks "$sub_test_name" $test_number

    test_number=$((test_number + 1))
    sub_test_name="map_struct"
    prog=./obj/map_struct.o
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
    compare_ft_nm_error_with_expected_output "$sub_test_name" $test_number "ft_nm: $prog: fail to find string tab"
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

if [ $TEST_BONUS -eq 1 ] || [ $TEST_ALL -eq 1 ]
then
    test_Bonus
fi

rm valgrind.out
echo
echo "nice one dude!"