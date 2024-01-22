section .data ; constants
	msg: db 'Input a number', 0xa ; db = define bytes 0xa = \n
	msg_len: equ $-msg
	msg_even: db 'Number is even', 0xa
	msg_even_len: equ $-msg_even
	msg_odd: db 'Number is odd', 0xa
	msg_odd_len: equ $-msg_odd

	debug: db 'DEBUG', 0xa
	debug_len: equ $-debug

	newLine: db 0xa

	input: dd 0 ; Stores converted ASCII value

section .bss ; Block Started by Symbol // variables
	inp_buffer: resb 10 ; reserve block of 10 bytes

section .text
	global _start

terminate:
	mov rax, 60  ; 60 is code for 'exit'
	mov rdi, 0	 ; Exit code 0
	syscall		 ; pokes kernel to call rax

_start:
	mov rax, 1		 ; set to 1 = write
	mov rdi, 1		 ; set to 1 = stdout (standard out)
	mov rsi, msg	 ; points to msg
	mov rdx, msg_len ; points to msg_len
	syscall

	; User input
	mov rax, 0			; set to 0 = sys_read
	mov rdi, 0			; set to 0 = stdin (standard in)
	mov rsi, inp_buffer ; rsi points to buffer where input will be saved
	mov rdx, 10			; Maximum bytes to read
	syscall

	; ASCII to integer
	mov rdi, inp_buffer
	call ascii_to_int

	test rax, 1		; Test least significant bit (LSB)
	jz .even		; Jump to even if LSB = 0
	jmp .odd		; Else jump to odd

	mov rax, 1		 ; set to 1 = write
	mov rdi, 1		 ; set to 1 = stdout (standard out)
	mov rsi, msg	 ; points to msg
	mov rdx, msg_len ; points to msg_len
	syscall

.even:
	mov rax, 1
	mov rdi, 1
	mov rsi, msg_even
	mov rdx, msg_even_len
	syscall

	jmp terminate

.odd:
	mov rax, 1
	mov rdi, 1
	mov rsi, msg_odd
	mov rdx, msg_odd_len
	syscall

	jmp terminate

; Function converting ASCII to int
; Input rdi pointing to ASCII string/buffer
; Output rax int value
ascii_to_int:
	xor rax, rax

.next_digit:
	movzx rcx, byte [rdi] ; Load the next byte from the ASCII string
	cmp rcx, 10			  ; Check if End of Line char
	je .done
	
	sub rcx, '0'	; Convert ASCII to int
	imul rax, 10	; Multiply result with 10
	add rax, rcx	; Add new digit to result
	inc rdi			; move to next char
	jmp .next_digit

.done:
	ret
