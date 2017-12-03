TITLE		PROCEDURE (COM)
			.MODEL 	SMALL
			.STACK	64
			.CODE
			ORG		100H
			JMP 	A10MAIN
XMSG		DB		? 
YMSG		DB		? 
MOVEMENT	DB 		? 
NEW_INPUT 	DB 		? 


;-------------------------------------------
A10MAIN		PROC	FAR

			;set DS to address of code segment
			MOV		AX, @CODE
			MOV 	DS, AX

			;clear screen
			CALL	_CLEAR_SCREEN

			MOV		XMSG, 40
			MOV 	YMSG, 12

			;set default movement to right
			MOV 	MOVEMENT, 00

	ITERATE:	
			; clear margin upper
			MOV		AX, 0600H
			MOV		BH, 0000H
			MOV 	CX, 0000H
			MOV		DX, 004FH
			INT		10H

			; clear margin left
			MOV		AX, 0600H
			MOV		BH, 0000H
			MOV 	CX, 0000H
			MOV		DX, 1800H
			INT		10H

			;clear screen
			CALL	_CLEAR_SCREEN

			;set cursor
			MOV		DL, XMSG
			MOV		DH, YMSG
			CALL	_SET_CURSOR

			JMP 	LISTENER

	PRINT:	
			;clear screen
			CALL	_CLEAR_SCREEN

			;display char from register
			MOV		AL, 41H
			MOV		AH, 02H
			MOV		DL, AL
			INT		21H

			CALL	_DELAY

			CMP MOVEMENT, 00
			JE RIGHT

			CMP MOVEMENT, 01
			JE LEFT

			CMP MOVEMENT, 02
			JE UP

			CMP MOVEMENT, 03
			JE DOWN 	

	BOUND_X:
			; bounds checks
			CMP		XMSG, 78
			JE	 	X_MAX

			CMP		XMSG, 00
			JE	 	X_MIN

			JMP		ITERATE
	BOUND_Y:
			CMP		YMSG, 24
			JE	 	Y_MAX

			CMP		YMSG, 00
			JE	 	Y_MIN		

			JMP		ITERATE

	; bounds reset	
	X_MIN:
		MOV 	XMSG, 78
		JMP 	ITERATE
	X_MAX:
		MOV 	XMSG, 01
		JMP 	ITERATE
	Y_MIN:
		MOV 	YMSG, 23
		JMP 	ITERATE
	Y_MAX:
		MOV 	YMSG, 01		
		JMP 	ITERATE

	;making the movement1
	RIGHT:
		INC XMSG		
		JMP BOUND_X
	LEFT:
		DEC XMSG		
		JMP BOUND_X
	UP:
		DEC YMSG	
		JMP BOUND_Y
	DOWN:
		INC YMSG	
		JMP BOUND_Y 

	;setting the movement
	SET_RIGHT:
		MOV MOVEMENT, 00		
		JMP PRINT
	SET_LEFT:
		MOV MOVEMENT, 01		
		JMP PRINT
	SET_UP:
		MOV MOVEMENT, 02		
		JMP PRINT
	SET_DOWN:
		MOV MOVEMENT, 03		
		JMP PRINT

	LISTENER:
			; listen for inputs
			CALL _GET_KEY 
 
			; ESC
			CMP NEW_INPUT, 1B
			JE _TERMINATE

			; RIGHT
			CMP NEW_INPUT, 4DH
			JE SET_RIGHT

			; LEFT
			CMP NEW_INPUT, 4BH
			JE SET_LEFT

			; UP
			CMP NEW_INPUT, 48H
			JE SET_UP

			; DOWN
			CMP NEW_INPUT, 50H
			JE SET_DOWN

			CMP NEW_INPUT, 01
			JGE STOP

			JMP PRINT

	STOP:
			;set cursor
			MOV		DL, XMSG
			MOV		DH, YMSG
			CALL	_SET_CURSOR
			;clear screen
			CALL	_CLEAR_SCREEN
			;display char from register
			MOV		AL, 41H
			MOV		AH, 02H
			MOV		DL, AL
			INT		21H
		JMP LISTENER

A10MAIN		ENDP
;-------------------------------------------
_TERMINATE PROC	NEAR
			;set cursor
			MOV		DL, 22H
			MOV		DH, 11
			CALL	_SET_CURSOR

			;set cursor
			MOV		DL, 01
			MOV		DH, 24
			CALL	_SET_CURSOR

			MOV		AX, 4C00H
			INT		21H
_TERMINATE ENDP
;-------------------------------------------
_CLEAR_SCREEN PROC	NEAR

			MOV		AX, 0600H
			MOV		BH, 074H
			MOV 	CX, 0101H
			MOV		DX, 174EH
			INT		10H

			RET
_CLEAR_SCREEN ENDP
;-------------------------------------------
_SET_CURSOR PROC	NEAR
			MOV		AH, 02H
			MOV		BH, 00
			INT		10H
			RET
_SET_CURSOR ENDP
;-------------------------------------------
_DELAY PROC	NEAR
			mov bp, 2 ;lower value faster
			mov si, 2 ;lower value faster
		delay2:
			dec bp
			nop
			jnz delay2
			dec si
			cmp si,0
			jnz delay2
			RET
_DELAY ENDP
;-------------------------------------------
_GET_KEY	PROC	NEAR
			MOV		AH, 01H		;check for input
			INT		16H

			JZ		__LEAVETHIS

			MOV		AH, 00H		
			INT		16H

			MOV		NEW_INPUT, AH

	__LEAVETHIS:
			RET
_GET_KEY 	ENDP

END 	A10MAIN

