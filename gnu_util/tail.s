.global _start
.section .bss
buffer: .skip 131072 @ 128kb
.section .data
err: .ascii "tail: file open failed\n"
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
	mov r5,#0 @total bytes in buffer

read_all:
	mov r7,#3 @read syscall
	mov r0,r4 @fd
	ldr r1, =buffer
	add r1,r1,r5 @offset into buffer
	mov r2,#131072
	sub r2,r2,r5 @remaining space
	swi 0

	cmp r0,#0
	beq find_lines

	add r5,r5,r0 @total bytes += bytes read
	b read_all

find_lines:
	mov r6,#10 @line count (default 10)
	sub r8,r5,#1 @start from end of buffer

scan_back:
	cmp r8,#0 @check if we reached start
	blt print_all @print entire buffer

	ldr r1, =buffer
	ldrb r0,[r1,r8] @load byte at buffer[r8]
	cmp r0,#10 @check for newline
	bne prev_char

	sub r6,r6,#1 @decrement line count
	cmp r6,#0
	beq print_tail @found enough lines

prev_char:
	sub r8,r8,#1
	b scan_back

print_all:
	mov r7,#4 @write syscall
	mov r0,#1 @stdout
	ldr r1, =buffer
	mov r2,r5 @write all bytes
	swi 0
	b exit

print_tail:
	add r8,r8,#1 @skip past the newline we stopped at
	mov r7,#4 @write syscall
	mov r0,#1 @stdout
	ldr r1, =buffer
	add r1,r1,r8 @start from position after newline
	sub r2,r5,r8 @write remaining bytes
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
