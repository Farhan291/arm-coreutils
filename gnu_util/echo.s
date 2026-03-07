.global _start
.section .data
newline: .ascii "\n"
space: .ascii " "
.section .text
_start:
        ldr r3,[sp] @top of stack contains argc
        mov r5,#1   @ i=1 for loop
loop:                             
        cmp r5,r3   @compare r5 and r3
        bge exit    @exit if r5>=r3   
                                   
        add r4,sp,#4  @always make r4 intially to argv[0] 
        add r4,r4,r5,lsl #2  @ r4=r4+r5*4 or r4=argv[i]  
        ldr r4,[r4]                                    
        mov r2,#0  
                 
strlen_loop:
        ldrb r6,[r4,r2]  @load byte at r4 start and no. of bytes=r2 to r6
        cmp r6,#0                                                       
        beq write
        add r2,r2,#1
        b strlen_loop
                     
write:
        mov r7,#4 @write argv[i]
        mov r0,#1
        mov r1,r4
        mov r2,r2
        swi 0    
             
        mov r7,#4 @write space
        mov r0,#1             
        ldr r1, =space
        mov r2,#1     
        swi 0    
             
        add r5,r5,#1
        b loop      
              
exit:
        mov r7,#4 @write newline
        mov r0,#1
        ldr r1, =newline
        mov r2,#1       
        swi 0    
             
        mov r7,#1
        mov r0,#0
        swi 0    
