.global _start
.section .bss
buffer: .skip 131072 @ 128kb
.section .data
err: .ascii "tee: file open failed\n"
len= . -err
.section .text
_start:
	add r3,sp,#8 @r3=argv[1] (output file)

	mov r7,#5 @open syscall
	ldr r0,[r3] @filename
	mov r1,#577 @O_WRONLY|O_CREAT|O_TRUNC
	mov r2,#0644 @mode
	swi 0

	cmp r0,#0
	blt error

	mov r4,r0 @fd of output file

loop:
	mov r7,#3 @read syscall
	mov r0,#0 @fd=stdin
	ldr r1, =buffer
	mov r2,#131072
	swi 0

	cmp r0,#0
	beq exit

	mov r5,r0 @no. of bytes read

	mov r7,#4 @write to stdout
	mov r0,#1
	ldr r1, =buffer
	mov r2,r5
	swi 0

	mov r7,#4 @write to file
	mov r0,r4
	ldr r1, =buffer
	mov r2,r5
	swi 0

	b loop

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
