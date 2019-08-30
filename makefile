# command options
AS := as
LD := ld
RM := rm -rf

.PHONY: clean

fizzbuzz: fizzbuzz.o
	$(LD) -o $@ $?

fizzbuzz.o: fizzbuzz.s
	$(AS) -o $@ $?

clean:
	$(RM) fizzbuzz fizzbuzz.o