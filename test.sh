#/bin/sh

nm $1 > test3
./nm $1 > test2
diff test2 test3
