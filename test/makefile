all: calc

calc: calc.o main_C_test.o
	gcc -m32 -g -Wall -o calc calc.o main_C_test.o
	
main_C_test.o: main_C_test.c
	gcc -g -Wall -m32 -c -o main_C_test.o main_C_test.c

calc.o: calc.s
	nasm -g -f elf -w+all -o calc.o calc.s

.PHONY: clean

clean: 
	rm -f *.o calc