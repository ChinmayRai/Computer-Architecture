	.equ SWI_Exit, 0x11
	.equ SWI_Open, 0x66
	.text

    b K
fun: 
	mov r7,#1000
	sub r7,r7,#1
	mov r1,#0
	mov r2,#0
	mov r3,#0
G:
	cmp r0,r7
	ble S
	sub r0,r0,#1000
	add r3,r3,#1
	b G
S:  
	cmp r0,#99
	ble A
	sub r0,r0,#100
	add r2,r2,#1
	b S

A:
	cmp r0,#9
	ble B
	sub r0,r0,#10
	add r1,r1,#1
	b A

B:  
	mul r7,r0,r0
	mul r0,r1,r1
	mul r1,r2,r2
	mul r2,r3,r3
	add r0,r0,r7
	add r0,r0,r1
	add r0,r0,r2
	b Y

K:  
	mov r4,#100
	mul r5,r4,r4      
	sub r5,r5,#1
	ldr r6,=P
	mov r8,r6
	mov r4,#1

L:  cmp r4,r5
	beq H
	mov r0,r4

D:	b fun
Y:	cmp r0,#1
	bne E
	str r4,[r6]
	add r6,r6,#4
	b J

E:  cmp r0,#4
	beq J
	b D


J:
	add r4,r4,#1
	b L
H:

	swi SWI_Exit
	.data
P:  .space 3000
X:  .asciz "output.txt"
Z:  .word 0
	.end