.global _start
.section .data
var1: .word 4
var2: .word 2
.section .text
_start:
	ldr r1,= var1
	ldr r0,[r1]
	ldr r2,=var2
	ldr r3,[r2]
	adds r3,r0,r3
	adds r3,r3,#48
	str r3,[r2]
	
	mov r7,#4
	mov r0,#1
	ldr r1, =var2
	mov r2,#4
	swi 0
	
	mov r7,#1
	mov r0,#0
	swi 0

