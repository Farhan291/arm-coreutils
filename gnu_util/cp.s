.global _start
.section .bss
buffer: .skip 131072 @ 128kb
.section .data
err: .ascii "cp: file open failed\n"
len= . -err
.section .text
_start:
	add r3,sp,#8 @ src
	add r4,sp,#12 @ des
	
	mov r7,#5 @ open src
	ldr r0,[r3]
	mov r1,#0
	swi 0
	
	cmp r0,#0
	blt error

	mov r5,r0 @fd of src
	
	mov r7,#5 @open des
	ldr r0,[r4]
	mov r1,#577
	mov r2,#0644
	swi 0

	cmp r0,#0
	blt error
	
	mov r6,r0 @fd of des
	
loop:
	mov r7,#3 @ read src
	mov r0,r5 
	ldr r1, =buffer
	mov r2,#131072
	swi 0
	
	cmp r0,#0
	beq exit

	mov r2,r0
	
	mov r7,#4
	mov r0,r6
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
	
	
	
	
