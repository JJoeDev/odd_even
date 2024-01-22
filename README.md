# odd_even
This is just me playing around trying to understand nasm x86_64 assembly

To run simply make sure ```nasm``` and ```ld``` is installed on your linux system

run

```nasm -f elf64 -o odd_even.o odd_even.asm```

```ld -o odd_even odd_even.o```

```./odd_even```
