.global _start
.section .data
err: .ascii "mv: file move failed\n"
len= . -err
.section .text
_start:
	add r3,sp,#8 @oldname
	add r4,sp,#12 @newname
	
	mov r7,#38
	ldr r0,[r3]
	ldr r1,[r4]
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
	b exit
	
exit: 
	mov r7,#1
	mov r0,#0
	swi 0
