CFLAGS=-m32
AFLAGS=-f elf

build: calculator

calculator: calculator.o includes/ASTUtils.o includes/macro.o
	gcc $^ -o $@ $(CFLAGS)

calculator.o: calculator.asm
	nasm $^ -o $@ $(AFLAGS)

clean:
	rm -rf *.o calculator
