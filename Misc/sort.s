	.equ SWI_Exit, 0x11
	.text
	
	mov r7,#0
	mov r8,#10
	mov r10,#4
	ldr r1,=P

loop1:
	sub r8,r8,#1
	mov r6,#0
	
loop2:  
	mul r9,r6,r10
	add r2,r1,r9
	add r2,r2,#4
	
    ldr r4,[r1,#0]
	ldr r5,[r2,#0]
	
	cmp r4,r5
	blt dontswap
	
	str r4,[r2,#0]
	str r5,[r1,#0] 

dontswap:
	add r6,r6,#1
	cmp r6,r8
	blt loop2

	add r1,r1,#4
	add r7,r7,#1
	cmp r7,#9
	blt loop1
    
    ldr r1,=P
 
 	swi SWI_Exit
	.data
P:  .word 4, 10, 6, 19, 3, 12, 67, 35, 66, 72     @initiliasing the array
	.end
