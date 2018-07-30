	.equ SWI_Exit, 0x11
	.text
aa:

	mov r1,#4
	mov r2,r1,lsl #1
	add r3,r2,r1
	mul r4,r3,r2
	ldr r5,[r1]
	str r4,[r2]
	b aa
	swi SWI_Exit
	.data
	.end
