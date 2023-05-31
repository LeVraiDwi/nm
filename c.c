#include <stdio.h>

void salut(int c) {
	int nb = c;

	printf("%d\n", nb);
}

void indirect(void (*fn)(int c)) {
	fn(2);
}

int main() {
	indirect(&salut);
	salut(4);
	return 1;
}
