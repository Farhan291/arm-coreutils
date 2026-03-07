.global _start
.section .bss
var: .skip 4
.section .text
_start:
	ldr r0,[sp]
	add r0,r0,#48
	ldr r1, =var
	str r0,[r1]
	
	mov r7,#4
	mov r0,#1
	ldr r1, =var
	mov r2,#4
	swi 0
	
	mov r7,#1
	mov r0,#0
	swi 0

	
