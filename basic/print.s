.global _start
.section .bss
var1: .skip 4
.section .text
_start:
	ldr r1, =var1 @get memory address of var1 and load it into r1 
	mov r0,#49     @r0=1
	str r0,[r1]   @store var1=1
	
	mov r7,#4     @write syscall
	mov r0,#1     @fd=stdout
	ldr r1, =var1 @write buffer address
	mov r2,#1     @no of bytes to write
	swi 0

	mov r7,#1
	mov r0,#0
	swi 0
