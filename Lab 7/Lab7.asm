TITLE PALINDROME (.EXE MODEL)
;-----------------------------------------
STACKSEG SEGMENT PARA 'Stack'
STACKSEG ENDS
;-----------------------------------------
DATASEG SEGMENT PARA 'Data'
	MEESAGE1 DB 0AH, "INPUT 1> ", '$'
	MESSAGE2 DB "INPUT 2> ", '$'
	MESSAGE3 DB "It's just '", '$'
	MESSAGE4 DB "'!", 0AH, '$'

	BOTH_PASS DB "You got 2 palindromes!", 0AH, '$'
	NO_PASS DB "Finals is coming!", 0AH, '$'

	EXIT_MSG DB "Program terminated successfully!", 0AH, '$'

	INPUT DB 31 DUP (?)
	HALF_STR_LEN DW ?
	STR_LEN DW ?

	IS_PALIN DB 'N'

	INPUT1 DB 31 DUP ('$')
	STR1_IS_PALIN DB 'N'
	INPUT2 DB 31 DUP ('$')
	STR2_IS_PALIN DB 'N'

DATASEG ENDS
;-----------------------------------------------------------
CODESEG SEGMENT PARA 'Code'
	ASSUME SS:STACKSEG, DS:DATASEG, CS:CODESEG
START:
_MAIN PROC FAR
	
	MOV AX, DATASEG
	MOV DS, AX
	MOV ES, AX

_MAIN ENDP
;-------------------------------------------------------------
START_PROG PROC NEAR

; STRING 1 SCAN

	; clears the last inputted values
	CALL INPUT_RESET

	; displays the input characters in real time
	LEA DX, MEESAGE1			
	PUSH DX						
	CALL DISPLAY_MSG			

	; checks the inputted string / character
	LEA SI, INPUT				
	CALL INPUT_CHECK			
	MOV STR_LEN, AX 			

	; copy current string as string1 
	LEA DX, INPUT1				
	PUSH DX						
	CALL STR_COPY	

	; palindrome check
	CALL IF_PLAINDROME		

	CMP IS_PALIN, 'Y'			
	JNE STRING2_SCAN					

	MOV STR1_IS_PALIN, 'Y' 			

STRING2_SCAN:

;same as first string check
	CALL INPUT_RESET

	LEA DX, MESSAGE2				
	PUSH DX						
	CALL DISPLAY_MSG				

	LEA SI, INPUT				
	CALL INPUT_CHECK			
	MOV STR_LEN, AX 			
		
	LEA DX, INPUT2				
	PUSH DX						
	CALL STR_COPY			

	CALL IF_PLAINDROME		

	CMP IS_PALIN, 'Y'			
	JNE FINAL_CHECK 				

	MOV STR2_IS_PALIN, 'Y' 			


FINAL_CHECK:
	; string 1 check
	CMP STR1_IS_PALIN, 'Y'			
	JNE STR1_FAIL

	; string 2 check
	CMP STR2_IS_PALIN, 'Y'			
	JE BOTH_PALI				
	
	; string 1 is palindrom								
	LEA DX, INPUT1
	PUSH DX
	CALL ONE_PASS
	JMP RESTART

STR1_FAIL:
	; string 2 check
	CMP STR2_IS_PALIN, 'Y'		
	JNE BOTH_FAIL		
	
	; string 2 is palindrome								
	LEA DX, INPUT2
	PUSH DX
	CALL ONE_PASS
	JMP RESTART

BOTH_FAIL:				
	MOV AH, 09H				
	LEA DX, NO_PASS
	INT 21H
	JMP RESTART

BOTH_PALI:					
	MOV AH, 09H				
	LEA DX, BOTH_PASS
	INT 21H			

RESTART:
	CALL FULL_RESET
	CALL START_PROG

START_PROG ENDP
;-----------------------------------------
IF_PLAINDROME PROC NEAR
	
							
	MOV AX, STR_LEN			
	MOV BL, 2
	; AX = AX / BL 				
	DIV BL 
	; clear remainder
	MOV AH, 00H

	; save half string length
	MOV HALF_STR_LEN, AX 	
	
	; set index to start of string
	LEA SI, INPUT
	; store string to ax	 		
	LEA AX, INPUT
	; set counter as string length			
	MOV CX, STR_LEN
	; set pointer to end of string        
	ADD AX, CX				
	; set destination index to end of string
	MOV DI, AX
	; keep index in index range				
	DEC DI

	; set counter to half of string length
	MOV CX, HALF_STR_LEN
	CHECK_CHARS:
	    MOV AL, [SI]
	    MOV AH, [DI]
	    ;compare letters for palindrome check
	    CMP AL, AH
	    JNE CHECK_OUT

	    INC SI
	    DEC DI

	    LOOP CHECK_CHARS

	PALINDROME:
		MOV IS_PALIN, 'Y'		

	JMP CHECK_OUT
	
    CHECK_OUT:
		RET
IF_PLAINDROME ENDP
;-----------------------------------------
INPUT_CHECK PROC NEAR
	MOV CX, SI 		        
	
    READ:
    	; read input
    	MOV AH, 01H				
        INT 21H

        ; enter press
        CMP AL, 13				
        JE DONE

        ; space press                
        CMP AL, 32				
        JE PASS

        ; check if upper				
        CMP AL, 97				
        JL NEXT					
        SUB AL, 32				

        NEXT:
	        MOV [SI], AL		
	        INC SI              
        
        PASS:
	        JMP READ            

    DONE:
    	MOV AL, '$'				
        MOV [SI], AL            
        MOV AX, SI              
        SUB AX, CX              

        ; single character case
        CMP AX, 1				
        JE END_CHECK
        RET

    QUIT:
    	CALL _TERMINATE

    END_CHECK:    	
    	; if Q / q quit program
    	CMP INPUT[0], 'Q'		
    	JE QUIT
    	RET

INPUT_CHECK ENDP
;-----------------------------------------
ONE_PASS PROC NEAR
	PUSH BP					
	MOV BP, SP				

	MOV AH, 09H
	LEA DX, MESSAGE3
	INT 21H

	MOV AH, 09H
	MOV DX, [BP+4]			
	INT 21H

	MOV AH, 09H
	LEA DX, MESSAGE4
	INT 21H

	MOV SP, BP		
	POP BP			
	RET 2			
ONE_PASS ENDP
;-----------------------------------------
DISPLAY_MSG PROC NEAR
	PUSH BP					
	MOV BP, SP				
	MOV AH, 09H

	MOV DX, [BP+4]			
	INT 21H

	MOV SP, BP		
	POP BP			
	RET 2			
DISPLAY_MSG ENDP
;-----------------------------------------
INPUT_RESET PROC NEAR

									
	MOV CX, 31 						
	MOV SI, 0000 					
	B10:
		MOV INPUT[SI], '?' 		
		INC SI 						
		LOOP B10 					


	MOV STR_LEN, 0000
	MOV HALF_STR_LEN, 0000

	MOV IS_PALIN, 'N'

	RET
INPUT_RESET ENDP
;-----------------------------------------
FULL_RESET PROC NEAR
	; reset boolean values
	MOV STR1_IS_PALIN, 'N'
	MOV STR2_IS_PALIN, 'N'

	; clear string 1									
	MOV CX, 31 						
	MOV SI, 0000 					
	STRING1_CLEAR:
		MOV INPUT1[SI], '$' 		
		INC SI 						
		LOOP STRING1_CLEAR 					

	; clear string 2								
	MOV CX, 31 						
	MOV SI, 0000 					
	STRING2_CLEAR:
		MOV INPUT2[SI], '$' 		
		INC SI 						
		LOOP STRING2_CLEAR 					

	RET
FULL_RESET ENDP
;-----------------------------------------
STR_COPY PROC NEAR
	PUSH BP
	MOV BP, SP
						
	CLD             			
	MOV CX, STR_LEN        		
	MOV DI, [BP+4]  			
	LEA SI, INPUT  			
	REP MOVSB

	MOV SP, BP
	POP BP
	RET 2
STR_COPY ENDP
;-----------------------------------------
_CLEAR_SCREEN PROC NEAR
	
	MOV AX, 0600H 			
	MOV BH, 07H			
	MOV CX, 0000H			
	MOV DX, 184FH			
	INT 10H

  RET
_CLEAR_SCREEN ENDP
;--------------------------------------------------
_SET_CURSOR PROC	NEAR
	MOV	AH, 02H		
	MOV	BH, 00		
	INT	10H

	RET
_SET_CURSOR ENDP
;--------------------------------------------------
_TERMINATE PROC NEAR
	MOV AH, 09H
	LEA DX, EXIT_MSG
	INT 21H

	MOV AH, 4CH		
	INT 21H
_TERMINATE ENDP
;-----------------------------------------
CODESEG ENDS
END START