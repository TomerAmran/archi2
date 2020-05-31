all: clean calc

calc: calc.o debug.o
	gcc -m32 -Wall -g calc.o debug.o -o calc

calc.o: calc.s
	nasm -f elf calc.s -o calc.o 

debug.o: debug.c
	gcc -m32 -c -Wall -g debug.c -o debug.o

clean: 
	rm -f  *.o calc macros.s