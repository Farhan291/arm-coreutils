.global _start
.section .bss
buffer: .skip 131072 @ 128kb
.section .data
err: .ascii "head: file open failed\n"
len= . -err
.section .text
_start:
	add r3,sp,#8 @r3=argv[1] (input file)

	mov r7,#5 @open syscall
	ldr r0,[r3] @filename
	mov r1,#0 @flags
	mov r2,#0444 @mode
	swi 0

	cmp r0,#0
	blt error

	mov r4,r0 @fd of input file
	mov r5,#10 @line count (default 10)

loop:
	mov r7,#3 @read syscall
	mov r0,r4 @fd
	ldr r1, =buffer
	mov r2,#131072
	swi 0

	cmp r0,#0
	beq exit

	mov r6,r0 @bytes read
	mov r8,#0 @buffer index
	mov r9,#0 @write start index

scan:
	cmp r8,r6 @check if we reached end of buffer
	bge write_all

	ldr r1, =buffer
	ldrb r0,[r1,r8] @load byte at buffer[r8]
	cmp r0,#10 @check for newline
	bne next_char

	sub r5,r5,#1 @decrement line count
	cmp r5,#0
	beq write_last @found enough lines

next_char:
	add r8,r8,#1
	b scan

write_all:
	mov r7,#4 @write syscall
	mov r0,#1 @stdout
	ldr r1, =buffer
	mov r2,r6 @write all bytes read
	swi 0
	b loop

write_last:
	add r8,r8,#1 @include the newline
	mov r7,#4 @write syscall
	mov r0,#1 @stdout
	ldr r1, =buffer
	mov r2,r8 @write up to and including last newline
	swi 0
	b exit

error:
	mov r7,#4
	mov r0,#1
	ldr r1, =err
	mov r2,#len
	swi 0
	b exit

exit:
	mov r7,#6 @close file
	mov r0,r4
	swi 0

	mov r7,#1
	mov r0,#0
	swi 0
