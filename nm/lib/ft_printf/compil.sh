make
echo "						============						"
clang -I "./include" $1  main.c libftprintf.a 
echo "						============						"
./a.out
echo "						============						"
make clean
