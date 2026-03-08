.global _start
.section .data
err: .ascii "rmdir: failed directory cannot be removed\n"
len= . -err
.section .text
_start:
	add r1,sp,#8
	
	mov r7,#40
	ldr r0,[r1]
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
