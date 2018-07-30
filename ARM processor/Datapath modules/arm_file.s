	.equ SWI_Exit, 0x11
	.text

	mov r1,#2
	mov r2,r1,lsl #1
	add r3,r2,r1
	mul r4,r3,r2
	ldr r5,[r1]
	str r4,[r2]
	mov r6,#252
	str r4,[r6]
	add r7,r6,r1
	ldr r8,[r7]
	swi SWI_Exit
	.data
	.end
