.global _start
.section .data
str: .ascii "hello , i love arm\n"
len= . -str
.section .text
_start:
	mov r7,#4
	mov r0,#1
	ldr r1, =str
	mov r2,#len
	swi 0
	mov r7,#1
	mov r0,#0
	swi 0

