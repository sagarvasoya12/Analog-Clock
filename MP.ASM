DATA SEGMENT
        XC DB 169,177,185,192,200,207,213,219,225,230,234,237,239,240,240,240,239,237,234,230,225,219,213,207,200,192,185,177,169,160,152,144,136,129,121,114,108,102,96,91,87,84,82,81,80,81,82,84,87,91,96,102,108,114,121,129,136,144,152,160
        YC DB 21,22,24,27,31,35,40,46,52,60,67,75,83,91,100,110,118,126,134,141,149,155,161,166,170,174,177,179,180,180,180,179,177,174,170,166,161,155,149,141,134,126,118,110,100,91,83,75,67,60,52,46,40,35,31,27,24,22,21,20
	XO DB 240,241,241,79,80,79,160,161,161,161,160,161,160,160,161,161,200,201,201,230,231,231,230,231,231,200,201,201,120,120,121,90,90,91,90,90,91,121,120,120
        YO DB 101,100,101,100,101,101,181,180,181,20,21,21,100,101,100,101,30,31,30,61,60,61,140,140,141,171,170,171,170,171,171,141,140,140,60,61,61,30,31,30 
	XN DB 25,28,30,28,25,20,15,11,9,11,15,20
	YN DB 3,7,12,17,21,23,21,17,12,7,3,2
	VI DB '01','02','03','04','05','06','07','08','09','10','11','12'
	H1 DB 'HOUR'
	M1 DB 'MINUTE'
	SE DB 'SECOND'
	TITLE1 DB 'ANALOG CLOCK'
	X1 DW 160
	X2 DW 160
        Y1 DW 20
	Y2 dw 100
	COLOR DB 02h
	COUNT DW 0
	X DW ?
	Y DW ?
	ERROR DW ?
	DIFFX DW ?
	FLAG DB 0
	DIFFY DW ?
	SWAP DW ?
	S1 DW ?
	S2 DW ?
	TEMP DW ?
	TEMP1 DW 0
        TEMP2 DW 1
        TEMP3 DW 1
	TEMP4 DW 5
DATA ENDS
STACK_SEG SEGMENT STACK
        DW 100 DUP(0)
        TOP_STACK LABEL WORD
STACK_SEG ENDS


CODE SEGMENT
        ASSUME CS:CODE,SS:STACK_SEG,DS:DATA,ES:DATA
START:  MOV AX,DATA
        MOV DS,AX
        MOV ES,AX
        MOV AX,STACK_SEG
        MOV ES,AX
        MOV SP,TOP_STACK
MEM2MEM MACRO A,B
	  MOV AX,B
	  MOV A,AX
  ENDM
	
        
	MOV CX,60
AGAIN:	MOV AX,0013H
        INT 10H
	;CALL BACKG
	CALL IDEN
        CALL CIRCLE
	CALL OTHER
	CALL NUMBER	
        CALL HOUR
        CALL MINUTE
	CALL SECOND
	JMP AGAIN
	

BACKBONE:MOV AH,07
         INT 21H
         CMP AL,27
         JNE BACKBONE
         INT 3

NUMBER PROC
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	PUSH BP
	PUSH ES
	PUSH DS
	POP ES

	LEA SI,XN
	LEA DI,YN
	MOV BX,0
REPEAT:	MOV CX,02
	MOV DL,DS:BYTE PTR[SI]
	MOV DH,DS:BYTE PTR[DI]
	LEA BP,VI[BX]
	PUSH BX
	MOV BX,000DH
	MOV AX,1300H
	INT 10H
	INC SI
	INC DI
	POP BX
	INC BX
	INC BX
	CMP BX,24
	JNZ REPEAT	

	POP ES
	POP BP
	POP DX
	POP CX
	POP BX
	POP AX
	RET
NUMBER ENDP
IDEN PROC
	MOV AL,color
	MOV BX,X2
	MOV CX,Y1
	MOV DX,Y2
	MOV BP,x1
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	PUSH BP
	
	MOV COLOR,02H
	MOV X1,0
	MOV Y1,196
	MOV X2,8
	MOV Y2,196
	CALL bresenham

	mov color,01                         
	MOV X1,0
	MOV Y1,188
	MOV X2,8
	MOV Y2,188
	call bresenham

	MOV color,0eh                           
	mov X1,0
	mov Y1,180
	MOV X2,8
	MOV Y2,180
	call bresenham

	MOV AX,1300H
	MOV BX,0004H
	MOV CX,4
	MOV DH,24
	MOV DL,2
	LEA BP,H1
	MOV SI,DS
	MOV ES,SI
	INT 10H
	
	MOV AX,1300H
	MOV BX,0004H
	MOV CX,6
	MOV DH,23
	MOV DL,2
	LEA BP,M1
	MOV SI,DS
	MOV ES,SI
	INT 10H
	
	MOV AX,1300H
	MOV BX,0004H
	MOV CX,6
	MOV DH,22
	MOV DL,2
	LEA BP,SE
	MOV SI,DS
	MOV ES,SI
	INT 10H
	
	MOV AX,1300H
	MOV BX,0004H
	MOV CX,12
	MOV DH,1
	MOV DL,15
	LEA BP,TITLE1
	MOV SI,DS
	MOV ES,SI
	INT 10H

	POP BP
	POP DX
	POP CX
	POP BX
	POP AX
	MOV X1,BP
	MOV X2,BX
	MOV Y1,CX
	MOV Y2,DX
	MOV color,AL 
	RET
IDEN ENDP
	
BACKG PROC
	PUSH AX
	PUSH BX
	
	MOV BX,000AH
	MOV AX,0C09H
	MOV CX,01H
REPEAT2:MOV DX,01H
REPEAT1:INT 10H
	INC DX
	CMP DX,200
	JNZ REPEAT1
	INC CX
	CMP CX,320
	JNZ REPEAT2 
	
	POP BX
	POP AX
	RET
BACKG ENDP


HOUR PROC
	PUSH AX
	PUSH CX
	PUSH DX
        PUSH BP

	
	MOV COLOR,02
	MOV AH,2CH
	INT 21H
	MOV CL,CH
	XOR CH,CH 
	MOV AX,CX
	MUL TEMP4
	MOV CX,AX
	SUB CX,1
	MOV BP,CX
	MOV AH,00H
	MOV AL,DS:XC[BP]
        MOV X1,AX
	MOV AL,DS:YC[BP]
	MOV Y1,AX	
        CALL bresenham

        POP BP
	POP DX
	POP CX
	POP AX
        RET
HOUR ENDP

MINUTE PROC
	PUSH AX
	PUSH CX
	PUSH DX
        PUSH BP

	MOV COLOR,01
	MOV AH,2CH
	INT 21H
	MOV CH,00H
	SUB CX,1	
	MOV BP,CX
	MOV AH,00H
	MOV AL,DS:XC[BP]
        MOV X1,AX
	MOV AL,DS:YC[BP]
	MOV Y1,AX	
        CALL bresenham  

	POP BP
	POP DX
	POP CX
	POP AX
        RET
MINUTE ENDP
	
		
SECOND PROC
	PUSH AX
	PUSH CX
	PUSH DX
        PUSH BP

        MOV COLOR,0Eh
	MOV AH,2CH
	INT 21H
	MOV DL,DH
	XOR DH,DH
        SUB DX,1
	MOV BP,DX
	MOV AH,00H
	MOV AL,DS:XC[BP]
        MOV X1,AX
	MOV AL,DS:YC[BP]
	MOV Y1,AX
	CALL bresenham
		

        POP BP
	POP DX
	POP CX
	POP AX
        RET
SECOND ENDP		

CIRCLE PROC 
	PUSH AX
	PUSH CX
	PUSH DX
        PUSH SI
	PUSH DI

        LEA SI,XC
        LEA DI,YC
        MOV CX,60
SAGAR:  MOV AX,0C04H
        PUSH CX
	MOV DH,00H
	MOV CH,00H
        MOV CL,DS:BYTE PTR[SI]
        MOV DL,DS:BYTE PTR[DI]
        INT 10H
        INC SI
        INC DI
        POP CX
        DEC CX
        CMP CX,00H
        JNZ SAGAR

	POP DI
	POP SI
	POP DX
	POP CX
	POP AX
        RET
CIRCLE ENDP

OTHER PROC
	PUSH AX
	PUSH CX
	PUSH DX
        PUSH SI
	PUSH DI
	
	LEA SI,XO
        LEA DI,YO
	MOV CX,40
SAGAR1: MOV AX,0C04H
	PUSH CX
        MOV DH,00H
	MOV CH,00H
	MOV CL,DS:BYTE PTR[SI]
	MOV DL,DS:BYTE PTR[DI]
	INT 10H
	INC SI
	INC DI
	POP CX
	DEC CX
	CMP CX,00H
	JNZ SAGAR1

	POP DI
	POP SI
	POP DX
	POP CX
	POP AX
        RET
OTHER ENDP

BRESENHAM PROC               ; Bresenham line algorithm
	  mov ax, y2
	  cmp ax, y1
	  jne cont3
	  mov ax, x2
	  cmp ax, x1
	  jne cont3
	  ret
  cont3 : mov ax, y2
	  sub ax, y1
	  jnc next1
	  neg ax
	  mov s2, 0
	  sub s2, 1
	  mov diffy, ax
	  jmp x3
 next1:   mov diffy, ax
	  cmp diffy, 0
	  je eq1
	  mov s2, 1
	  jmp x3
  eq1:    mov s2, 0
   x3:    mov ax, x2
	  sub ax, x1
	  jnc next2
	  neg ax
	  mov s1, 0
	  sub s1, 1
	  mov diffx, ax
	  jmp calc
 next2:   mov diffx, ax
	  cmp diffx, 0
	  je eq2
	  mov s1, 1
	  jmp calc
 eq2:     mov s1, 0
 calc:    mem2mem x, x1
	  mem2mem y, y1
	  mov ax, diffx
	  cmp diffy, ax
	  jnc more
	  mov swap, 0
	  jmp cont
  more:   mem2mem temp, diffx
	  mem2mem diffx, diffy
	  mem2mem diffy, temp
	  mov swap, 1
  cont:   mov ax, diffy
	  shl ax, 1
	  sub ax, diffx
	  mov error, ax
	  mov count, 1
   for:   call putpixel
  while1:  cmp error, 0
	  jl fin
	  cmp swap, 1
	  je forx
	  mov ax, y
	  add ax, s2
	  mov y, ax
	  jmp fory
   forx:  mov ax, x
	  add ax, s1
	  mov x, ax
     fory:mov ax, diffx
	  shl ax, 1
	  sub error, ax
          jmp while1
    fin:  cmp swap, 1
	  je fry
	  mov ax, x
	  add ax, s1
	  mov x, ax
	  jmp frx
    fry:  mov ax, y
	  add ax, s2
	  mov y, ax
    frx:  mov ax, diffy
	  shl ax, 1
	  add error, ax
	  inc count
	  mov ax, diffx
	  cmp ax, count
	  jnc for
	  RET
BRESENHAM ENDP


PUTPIXEL PROC                  ; Put a pixel on screen
	  cmp flag, 0
	  je first
	  cmp y, 41
	  jc dontput
	  cmp y, 478
	  ja dontput
	  cmp x, 0
	  je dontput
	  cmp x, 638
	  ja dontput
  first : mov cx, x           ; Getting coordinates of
	  mov dx, y           ; target pixel.
	  mov ah, 0ch
	  mov al, color       ; Color of pixel.
	  int 10h
dontput : RET

ENDP PUTPIXEL

      
     CODE ENDS
  END START
         

