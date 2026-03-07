.global _start
.section .bss
buffer: .skip 1024
.section .data
err: .ascii "cat: file open failed\n" 
len= . -err
.section .text
_start:
	add r3,sp,#8 @r3=argv[1]
		
	mov r7,#5   @open syscall
	ldr r0,[r3] @filename 
	mov r1,#0   @flags
	mov r2,#0444 @mode
	swi 0
	
	cmp r0,#0
	blt error
	
	mov r4,r0
loop:
	mov r7,#3 @read syscall
	mov r0,r4 @fd
	ldr r1, =buffer
	mov r2,#1024
	swi 0
	
	cmp r0,#0
	beq exit

	mov r2,r0 @no. of bytes read 
	
	mov r7,#4
	mov r0,#1
	ldr r1, =buffer
	mov r2,r2
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
	mov r7,#1
	mov r0,#0
	swi 0
