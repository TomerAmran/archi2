all: clean calc


calc: calc.o
	gcc -m32 -Wall -g calc.o -o calc

calc.o: calc.s
	nasm -f elf calc.s -o calc.o 




clean: 
	rm -f  *.o calc macros.s