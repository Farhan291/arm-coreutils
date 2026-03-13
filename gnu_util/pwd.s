.global _start
.section .data
err: .ascii "pwd: failed\n"
len= . -err
newline: .ascii "\n"
.section .bss
buffer: .skip 1024 
.section .text
_start:
	mov r7,#0xb7
	ldr r0, =buffer
	mov r1,#1024
	swi 0

	cmp r0,#0
	blt error
	mov r2,r0
	
	mov r7,#4
	mov r0,#1
	ldr r1, =buffer
	mov r2,r2
	swi 0

	mov r7,#4
	mov r0,#1
	ldr r1, =newline
	mov r2,#1
	swi 0
	b exit
error:
	mov r7,#4
	mov r0,#1
	ldr r1, =err
	mov r2,#len
	swi 0
exit: 	
	mov r7,#1
	mov r0,#0
	swi 0
