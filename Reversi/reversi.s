.equ SWI_Exit, 0x11
.equ displaystring, 0x204
.equ displayinteger, 0x205
.equ SETLED, 0x201          @ r0=1:rht ; r0=2:lft ;r0=3: lft&rht 
.equ CHECKBLACK, 0x202
.equ CHECKBOARD, 0x203

	.text

	bl display_board
	mov r11,#1              @ label
Game:
	cmp r11,#1
	moveq r11,#0
	moveq r10,#1
	movne r11,#1
	movne r10,#0

	cmp r11,#0
	moveq r0,#2				@sets on l/r LED depending on whose chance it is
	cmp r11,#1
	moveq r0,#1
	swi SETLED
 
req:
	ldr r3,=P
	bl Read_address         @ reads the address of position where player wants to play
	bl chance
	cmp r0,#1
	bne req					@add an error of retry on this loop

	mov r0,#0
	mov r1,#0
	ldr r2,=board
	bl display_board

	b Game

chance:
	mov r12,lr          @r12 contains the master lr of chance
	
	ldr r0,[r3]
	sub r0,r0,#1
	str r0,[r3]            @ x= x_cord -1 and y = y_cord -1
	ldr r0,[r3,#4]
	sub r0,r0,#1
	str r0,[r3,#4]

	ldr r2,=valid
	mov r0,#0
	mov r1,#0
kk:
	cmp r0,#8
	beq kgp
	strb r1,[r2,#0]
	strb r1,[r2,#1]
	strb r1,[r2,#2]
	strb r1,[r2,#3]
	strb r1,[r2,#4]
	strb r1,[r2,#5]
	strb r1,[r2,#6]
	strb r1,[r2,#7]
	add r2,r2,#8
	add r0,r0,#1
	b kk
kgp:

check:				                               @the check func goes and modifies the valid array   
	mov r0,#0    @outer for loop
gg:
	mov r1,#0	@inner for loop
hh:
	bl get_bind      @checking if valid(x,y)=k
	cmp r6,r10
	bne jj

	cmp r0,#0
	bne gh

	cmp r1,#0
	bne gi
	
	add r0,r0,#1
	bl get_bind
	cmp r6,#2
	bleq set_valid
	add r1,r1,#1
	bl get_bind                  @r0=0,r1=0
	cmp r6,#2
	bleq set_valid
	sub r0,r0,#1
	bl get_bind
	cmp r6,#2
	bleq set_valid
	sub r1,r1,#1
							
	b ji
gi: cmp r1,#7
	bne hi

	add r0,r0,#1 
	bl get_bind
	cmp r6,#2
	bleq set_valid
	sub r1,r1,#1
	bl get_bind                  @r0=0,r1=7
	cmp r6,#2
	bleq set_valid
	sub r0,r0,#1
	bl get_bind
	cmp r6,#2
	bleq set_valid
	add r1,r1,#1

	b ji
hi:
    add r0,r0,#1
	bl get_bind 
	cmp r6,#2
	bleq set_valid
	add r1,r1,#1
	bl get_bind                  @r0=0,r1=_
	cmp r6,#2
	bleq set_valid
	sub r0,r0,#1
	bl get_bind
	cmp r6,#2
	bleq set_valid
	sub r1,r1,#2
	bl get_bind
	cmp r6,#2
	bleq set_valid
	add r0,r0,#1
	bl get_bind
	cmp r6,#2
	bleq set_valid
	sub r0,r0,#1
	add r1,r1,#1
	
ji:
	b jj

gh: cmp r0,#7
	bne hj

    cmp r1,#0
	bne gii
	
	sub r0,r0,#1
	bl get_bind
	cmp r6,#2
	bleq set_valid
	add r1,r1,#1
	bl get_bind                  @r0=7,r1=0
	cmp r6,#2
	bleq set_valid
	add r0,r0,#1
	bl get_bind
	cmp r6,#2
	bleq set_valid
	sub r1,r1,#1


	b jii
gii: cmp r1,#7
	bne hii

	sub r0,r0,#1
	bl get_bind
	cmp r6,#2
	bleq set_valid
	sub r1,r1,#1
	bl get_bind                  @r0=7,r1=7
	cmp r6,#2
	bleq set_valid
	add r0,r0,#1
	bl get_bind
	cmp r6,#2
	bleq set_valid
	add r1,r1,#1

	b jii
hii:
	sub r0,r0,#1
	bl get_bind
	cmp r6,#2
	bleq set_valid
	add r1,r1,#1
	bl get_bind                  @r0=7,r1=_
	cmp r6,#2
	bleq set_valid
	add r0,r0,#1
	bl get_bind
	cmp r6,#2
	bleq set_valid
	sub r1,r1,#2
	bl get_bind
	cmp r6,#2
	bleq set_valid
	sub r0,r0,#1
	bl get_bind
	cmp r6,#2
	bleq set_valid
	add r1,r1,#1
	add r0,r0,#1
	
jii:

	b jj
hj:

cmp r1,#0
	bne go

	add r1,r1,#1
	bl get_bind
	cmp r6,#2
	bleq set_valid
	add r0,r0,#1
	bl get_bind                  @r0=_,r1=0
	cmp r6,#2
	bleq set_valid
	sub r0,r0,#2
	bl get_bind
	cmp r6,#2
	bleq set_valid
	sub r1,r1,#1
	bl get_bind
	cmp r6,#2
	bleq set_valid
	add r0,r0,#2
	bl get_bind
	cmp r6,#2
	bleq set_valid
	sub r0,r0,#1

	b jo
go: cmp r1,#7
	bne ho

	sub r0,r0,#1
    sub r1,r1,#1
	bl get_bind
	cmp r6,#2
	bleq set_valid
	add r0,r0,#1
	bl get_bind                  @r0=_,r1=7
	cmp r6,#2
	bleq set_valid
	add r0,r0,#1
	bl get_bind
	cmp r6,#2
	bleq set_valid
	add r1,r1,#1
	bl get_bind
	cmp r6,#2
	bleq set_valid
	sub r0,r0,#2
	bl get_bind
	cmp r6,#2
	bleq set_valid
	add r0,r0,#1

	b jo
ho:
	sub r0,r0,#1
    sub r1,r1,#1
	bl get_bind
	cmp r6,#2
	bleq set_valid
	add r1,r1,#1
	bl get_bind                  @r0=_,r1=_
	cmp r6,#2
	bleq set_valid
	add r1,r1,#1
	bl get_bind
	cmp r6,#2
	bleq set_valid
	add r0,r0,#1
	bl get_bind
	cmp r6,#2
	bleq set_valid
	add r0,r0,#1
	bl get_bind
	cmp r6,#2
	bleq set_valid
	sub r1,r1,#1
	bl get_bind
	cmp r6,#2
	bleq set_valid
	sub r1,r1,#1
	bl get_bind
	cmp r6,#2
	bleq set_valid
	sub r0,r0,#1
	bl get_bind
	cmp r6,#2
	bleq set_valid
	add r1,r1,#1

	
jo:

jj:
	add r1,r1,#1
	cmp r1,#8
	blt hh
	add r0,r0,#1
	cmp r0,#8
	blt gg                           @check ends

Game_over:
	mov r4,#0    @val_count
	mov r0,#0    @outer for loop
g1:
	mov r1,#0	@inner for loop
h1:
	bl get_valid
	cmp r6,#1
	addeq r4,r4,#1

	add r1,r1,#1
	cmp r1,#8
	blt h1
	add r0,r0,#1
	cmp r0,#8
	blt g1 

check_valid:
	cmp r4,#0
	bne proceed
	mov r7,#0
	mov r8,#0
	mov r0,#0    @outer for loop
g2:
	mov r1,#0	@inner for loop
h2:
	bl get_bind
	cmp r6,#1
	addeq r8,r8,#1
	cmp r6,#0
	addeq r7,r7,#1

	add r1,r1,#1
	cmp r1,#8
	blt h2
	add r0,r0,#1
	cmp r0,#8
	blt g2 

	mov r0,#29
	mov r1,#4
	cmp r7,r8
	bgt owi
	ldr r2,=x_win
	swi displaystring
	mov pc,r12

owi: ldr r2,=o_win
	swi displaystring
	mov pc,r12

	mov r0,#0
	mov r1,#0
	mov r7,#0
	mov r8,#0
	mov r4,#0



proceed:
	ldr r0,[r3]
	ldr r1,[r3,#4]
	mov r2,#8
	mul r1,r2,r1
	add r0,r0,r1
	ldr r2,=valid
	ldrb r1,[r2,r0]
	cmp r1,#0	
	moveq r0,#0
	moveq pc,r12

traversal:
	ldr r1,[r3,#0]
	ldr r2,[r3,#4]                            
	mov r4,#0          @r4=flag

	mov r0,#-1          
	cmp r1,#0
	bne rx
	cmp r2,#0
	bne rxa

	bl right_traversal
	cmp r4,#0
	moveq r0,#1
	bl down_traversal
	cmp r4,#0
	moveq r0,#1
	bl right_down_traversal
	cmp r4,#0
	moveq r0,#1
	
	b rza
rxa: cmp r2,#7
	bne rya

	bl left_traversal
	cmp r4,#0
	moveq r0,#1
	bl down_traversal
	cmp r4,#0
	moveq r0,#1
	bl left_down_traversal
	cmp r4,#0
	moveq r0,#1
	b rza
rya:	

	bl right_traversal
	cmp r4,#0
	moveq r0,#1
	bl down_traversal
	cmp r4,#0
	moveq r0,#1
	bl left_traversal
	cmp r4,#0
	moveq r0,#1
	bl left_down_traversal
	cmp r4,#0
	moveq r0,#1
	bl right_down_traversal
	cmp r4,#0
	moveq r0,#1
	
rza:
	b rz
rx: cmp r1,#7
	bne ry
	cmp r2,#0
	bne rxb
 
 	bl right_traversal
 	cmp r4,#0
	moveq r0,#1
	bl up_traversal
 	cmp r4,#0
	moveq r0,#1
	bl right_up_traversal
	cmp r4,#0
	moveq r0,#1
	b rzb
rxb: cmp r2,#7
	bne ryb

	bl left_traversal
	cmp r4,#0
	moveq r0,#1
	bl up_traversal
	cmp r4,#0
	moveq r0,#1
	bl left_up_traversal
	cmp r4,#0
	moveq r0,#1
	b rzb
ryb:	

	bl right_traversal
	cmp r4,#0
	moveq r0,#1
	bl left_traversal
	cmp r4,#0
	moveq r0,#1
	bl up_traversal
	cmp r4,#0
	moveq r0,#1
	bl left_up_traversal
	cmp r4,#0
	moveq r0,#1
	bl right_up_traversal
	cmp r4,#0
	moveq r0,#1
rzb:	
	b rz
ry:	
    cmp r2,#0
	bne rxc

	bl right_traversal
	cmp r4,#0
	moveq r0,#1
	bl up_traversal
	cmp r4,#0
	moveq r0,#1
	bl down_traversal
	cmp r4,#0
	moveq r0,#1
	bl right_up_traversal
	cmp r4,#0
	moveq r0,#1
	bl right_down_traversal 
	cmp r4,#0
	moveq r0,#1
	b rzc
rxc: cmp r2,#7
	bne ryc

	bl left_traversal
	cmp r4,#0
	moveq r0,#1
	bl up_traversal
	cmp r4,#0
	moveq r0,#1
	bl down_traversal
	cmp r4,#0
	moveq r0,#1
	bl left_up_traversal
	cmp r4,#0
	moveq r0,#1
	bl left_down_traversal 
	cmp r4,#0
	moveq r0,#1
	b rzc
ryc:	

	bl left_traversal
	cmp r4,#0
	moveq r0,#1
	bl up_traversal
	cmp r4,#0
	moveq r0,#1
	bl down_traversal
	cmp r4,#0
	moveq r0,#1
	bl left_up_traversal
	cmp r4,#0
	moveq r0,#1
	bl left_down_traversal 
	cmp r4,#0
	moveq r0,#1
	bl right_traversal
	cmp r4,#0
	moveq r0,#1
	bl right_up_traversal
	cmp r4,#0
	moveq r0,#1
	bl right_down_traversal
	cmp r4,#0
	moveq r0,#1
rzc:							@traversal ends
rz:
	mov pc,r12



get_bind:               @ gets the bind value of r0,r1 in r6
	add r0,r0,r1,LSL #3
	ldr r2,=bind
	ldrb r6,[r2,r0]
	sub r0,r0,r1,LSL #3
	mov pc,lr

get_bnd:				@gets the bind valiue of r1,r2 in r6
	add r1,r1,r2,LSL #3
	ldr r5,=bind	
	ldrb r6,[r5,r1]
	sub r1,r1,r2,LSL #3
	mov pc,lr

set_bind:               @sets the value of bind at (r1,r2) to be equal to label
	add r1,r1,r2,LSL #3
	ldr r6,=bind
	strb r11,[r6,r1]
	sub r1,r1,r2,LSL #3
	mov pc,lr


set_valid:              @ sets the value of valid(r0,r1)=1
	add r0,r0,r1,LSL #3
	ldr r2,=valid
	mov r9,#1
	strb r9,[r2,r0]
	sub r0,r0,r1,LSL #3
	mov pc,lr 

get_valid:
	add r0,r0,r1,LSL #3
	ldr r2,=valid
	ldrb r6,[r2,r0]
	sub r0,r0,r1,LSL #3
	mov pc,lr


up_traversal:
	mov r3,lr
	mov r7,r1					@ x= r1, y= r2; label in r11;
    mov r4,#1			@r4 is the flag  @ gives utput in r4;k in r10

    sub r1,r1,#1
    bl get_bnd
    cmp r6,r10
    bne ut

ik:
	bl get_bnd
	cmp r6,r11
	moveq r4,#0
	beq ij

    sub r1,r1,#1
	cmp r1,#0
	bge ik

ij: cmp r4,#0
	bne ut
	add r1,r1,#1

il:
	bl get_bnd
	cmp r6,r11
	beq  um
	bl set_bind

	add r1,r1,#1
	cmp r1,r7
	ble il
um:
ut: mov r1,r7
    mov pc,r3


down_traversal:                @ gives utput in r4
	mov r3,lr
	mov r7,r1					@ x= r1, y= r2; label in r11;
    mov r4,#1			@r4 is the flag;k in r10

    add r1,r1,#1
    bl get_bnd
    cmp r6,r10
    bne ug

iki:
	bl get_bnd
	cmp r6,r11
	moveq r4,#0
	beq iji

    add r1,r1,#1
	cmp r1,#7
	ble iki

iji: cmp r4,#0
	bne ug
	sub r1,r1,#1
	
ili:
	bl get_bnd
	cmp r6,r11
	beq  umi
	bl set_bind

	sub r1,r1,#1
	cmp r1,r7
	bge ili
umi: 
ug: mov r1,r7
    mov pc,r3

right_traversal:           @ gives utput in r4
	mov r3,lr
	mov r7,r2				@ x= r1, y= r2; label in r11;
    mov r4,#1			@r4 is the flag;k in r10
  		
    add r2,r2,#1
    bl get_bnd
    cmp r6,r10
    bne ugl

ikl:
	bl get_bnd
	cmp r6,r11
	moveq r4,#0
	beq ijl

    add r2,r2,#1
	cmp r2,#7
	ble ikl

ijl: cmp r4,#0
	bne ugl	
	sub r2,r2,#1

ill:
	bl get_bnd
	cmp r6,r11
	beq  uml
	bl set_bind

	sub r2,r2,#1
	cmp r2,r7
	bge ill
uml: 
ugl:mov r2,r7
    mov pc,r3

left_traversal:				@ gives utput in r4	
	mov r3,lr
	mov r7,r2				@ x= r1, y= r2; label in r11;
    mov r4,#1			@r4 is the flag,k in r10

    sub r2,r2,#1
    bl get_bnd
    cmp r6,r10
    bne uhl

ihl:
	bl get_bnd
	cmp r6,r11
	moveq r4,#0
	beq ijh

    sub r2,r2,#1
	cmp r2,#0
	bge ihl

ijh: cmp r4,#0
	bne uhl	
	add r2,r2,#1

ilh:
	bl get_bnd
	cmp r6,r11
	beq  umh
	bl set_bind

	add r2,r2,#1
	cmp r2,r7
	ble ilh
umh: 
uhl:mov r2,r7 
    mov pc,r3

right_down_traversal:		@ gives utput in r4
	mov r3,lr
	mov r7,r1
	mov r8,r2			@ x= r1, y= r2; label in r11;
    mov r4,#1			@r4 is the flag,k in r10
    mov r9,#0

    add r1,r1,#1
    add r2,r2,#1	
    bl get_bnd
    cmp r6,r10
    sub r1,r1,#1
    sub r2,r2,#1
    bne rda

rdd:
	add r9,r9,#1
	add r1,r1,#1
	cmp r1,#8
	beq rdb
    add r2,r2,#1
    cmp r2,#8
	beq rdb
	bl get_bnd
	cmp r6,r11
	moveq r4,#0
	beq rdb
	b rdd

rdb: cmp r4,#0
	bne rda	
	sub r9,r9,#1

rdc:
	sub r1,r1,#1
	sub r2,r2,#1
	bl get_bnd
	cmp r6,r11
	beq  rde
	bl set_bind

	sub r9,r9,#1
	cmp r9,#0
	bge rdc

rde: 
rda:mov r1,r7
	mov r2,r8 
     mov pc,r3

right_up_traversal:			@ gives utput in r4
	mov r3,lr
	mov r7,r1
	mov r8,r2			@ x= r1, y= r2; label in r11;
    mov r4,#1			@r4 is the flag,k in r10
    mov r9,#0

    sub r1,r1,#1
    add r2,r2,#1	
    bl get_bnd
    cmp r6,r10
    add r1,r1,#1
    sub r2,r2,#1
    bne rua

rud:
	add r9,r9,#1
	sub r1,r1,#1
	cmp r1,#0
	beq rub
    add r2,r2,#1
    cmp r2,#8
	beq rub
	bl get_bnd
	cmp r6,r11
	moveq r4,#0
	beq rub
	b rud

rub: cmp r4,#0
	bne rua	
	sub r9,r9,#1

ruc:
	add r1,r1,#1
	sub r2,r2,#1
	bl get_bnd
	cmp r6,r11
	beq  rue
	bl set_bind

	sub r9,r9,#1
	cmp r9,#0
	bge ruc

rue:
rua:mov r1,r7
	mov r2,r8	
    mov pc,r3


left_up_traversal:			@ gives utput in r4
	mov r3,lr
	mov r7,r1
	mov r8,r2			@ x= r1, y= r2; label in r11;
    mov r4,#1			@r4 is the flag,k in r10
    mov r9,#0

    sub r1,r1,#1
    sub r2,r2,#1	
    bl get_bnd
    cmp r6,r10
    add r1,r1,#1
    add r2,r2,#1
    bne lua

lud:
	add r9,r9,#1
	sub r1,r1,#1
	cmp r1,#0
	beq lub
    sub r2,r2,#1
    cmp r2,#0
	beq lub
	bl get_bnd
	cmp r6,r11
	moveq r4,#0
	beq lub
	b lud

lub: cmp r4,#0
	bne lua	
	sub r9,r9,#1

luc:
	add r1,r1,#1
	add r2,r2,#1
	bl get_bnd
	cmp r6,r11
	beq lue
	bl set_bind

	sub r9,r9,#1
	cmp r9,#0
	bge luc

lue:
lua:mov r1,r7
	mov r2,r8 
    mov pc,r3

left_down_traversal:        @ gives utput in r4
	mov r3,lr
	mov r7,r1
	mov r8,r2			@ x= r1, y= r2; label in r11;k in r10
    mov r4,#1			@r4 is the flag
    mov r9,#0

    add r1,r1,#1
    sub r2,r2,#1	
    bl get_bnd
    cmp r6,r10
    sub r1,r1,#1
    add r2,r2,#1
    bne lda

ldd:
	add r9,r9,#1
	add r1,r1,#1
	cmp r1,#8
	beq ldb
    sub r2,r2,#1
    cmp r2,#0
	beq ldb
	bl get_bnd
	cmp r6,r11
	moveq r4,#0
	beq ldb
	b ldd

ldb: cmp r4,#0
	bne lda	
	sub r9,r9,#1

ldc:
	sub r1,r1,#1
	add r2,r2,#1
	bl get_bnd
	cmp r6,r11
	beq  lde
	bl set_bind

	sub r9,r9,#1
	cmp r9,#0
	bge ldc

lde:
lda:mov r1,r7
	mov r2,r8 
    mov pc,r3


Read_address:          @ before calling this ensure that r3 is an specified empty memory location
    mov r1,#0
    mov r2,#0
	mov r0,#0
keyb:
	swi CHECKBOARD
	cmp r0,#0
	beq keyb
	cmp r0,#1
	subeq r3,r3,#8
	moveq pc,lr


	mov r2,#0
	tst r0,#0xFF
	addeq r2,r2,#8
	moveq r0,r0,LSR #8
	tst r0,#0x0F
	addeq r2,r2,#4
	moveq r0,r0,LSR #4
	tst r0,#0x03
	addeq r2,r2,#2
	moveq r0,r0,LSR #2
	tst r0,#0x01
	addeq r2,r2,#1
	moveq r0,r0,LSR #1

	mov r0,#0
	str r2,[r3]
	add r3,r3,#4
	mov r0,#29
	mov r1,#4
	swi displayinteger
	mov r0,#0
	b Read_address


Set_X:                    @before calling this ensure that the address where you want to set X is stored at r0,r1
	add r0,r0,#1
	add r1,r1,#1
	ldr r2,=board
	cmp r0,#9
	bge error
	cmp r1,#9
	bge error
	mov r3,#18
	mul r3,r1,r3
	add r3,r3,r0,LSL #1
	mov r7,#'X
	strb r7,[r2,r3]
	sub r0,r0,#1
	sub r1,r1,#1
	mov pc,lr

Set_O:  
	add r0,r0,#1
	add r1,r1,#1                    @before calling this ensure that the address where you want to set O is stored at r3 
	ldr r2,=board
	cmp r0,#9
	bge error
	cmp r1,#9
	bge error
	mov r3,#18
	mul r3,r1,r3
	add r3,r3,r0,LSL #1
	mov r7,#'O
	strb r7,[r2,r3]
	sub r0,r0,#1
	sub r1,r1,#1
	mov pc,lr


display_board:
	mov r9,lr                      @ before calling this initialize r0 to 0, r1 to 0 and r2 to address of board_string 
	bl redraw
	ldr r2,=board
dispbrd:
	swi displaystring
	add r1,r1,#1
	add r2,r2,#18
	cmp r1,#9
	blt dispbrd
	mov pc,r9	


redraw:	
	mov r8,lr							@redrawing the board according to bind
	mov r0,#0    @outer for loop
rge:
	mov r1,#0	@inner for loop
rhe:
	bl get_bind
	cmp r6,#2
	beq rit
	cmp r6,#1
	bne rtt
	bl Set_X
	b rit
rtt:
	cmp r6,#0
	bl Set_O
rit:
	add r1,r1,#1
	cmp r1,#8
	blt rhe 
	add r0,r0,#1
	cmp r0,#8
	blt rge
	mov r0,#0
	mov r1,#0
	mov pc,r8

error:
	mov r0,#3
	swi SETLED

EOP:
swi SWI_Exit
	.data
P:  .space 400 


x_win: .asciiz "X wins"
o_win: .asciiz "O wins"
strng: .asciiz "Invalid Input"
board:
	.asciiz "0 1 2 3 4 5 6 7 8"
	.asciiz "1 _ _ _ _ _ _ _ _"
	.asciiz "2 _ _ _ _ _ _ _ _"
	.asciiz "3 _ _ _ _ _ _ _ _"
	.asciiz "4 _ _ _ X O _ _ _"
	.asciiz "5 _ _ _ O X _ _ _"
	.asciiz "6 _ _ _ _ _ _ _ _"
	.asciiz "7 _ _ _ _ _ _ _ _"
	.asciiz "8 _ _ _ _ _ _ _ _"

valid:
	.byte 0,0,0,0,0,0,0,0
	.byte 0,0,0,0,0,0,0,0
	.byte 0,0,0,0,0,0,0,0
	.byte 0,0,0,0,0,0,0,0
	.byte 0,0,0,0,0,0,0,0
	.byte 0,0,0,0,0,0,0,0
	.byte 0,0,0,0,0,0,0,0
	.byte 0,0,0,0,0,0,0,0

bind:
	.byte 2,2,2,2,2,2,2,2
	.byte 2,2,2,2,2,2,2,2
	.byte 2,2,2,2,2,2,2,2
	.byte 2,2,2,1,0,2,2,2                     @ 1=X and 0=O
	.byte 2,2,2,0,1,2,2,2
	.byte 2,2,2,2,2,2,2,2
	.byte 2,2,2,2,2,2,2,2
	.byte 2,2,2,2,2,2,2,2	
	.end
