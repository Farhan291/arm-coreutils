.global _start
.section .data
err: .ascii "mkdir: failed\n"
len= . -err
.section .text
_start:
	add r2,sp,#8 @pathname
	
	mov r7,#39  @mkdir syscall
	ldr r0,[r2]
	mov r1,#0755
	swi 0
	
	cmp r0,#0
	blt error
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

