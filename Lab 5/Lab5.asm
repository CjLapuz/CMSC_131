TITLE PROCEDURE (.EXE MODEL)
;---------------------------------------------
STACKSEG SEGMENT PARA 'Stack'
STACKSEG ENDS
;---------------------------------------------
DATASEG SEGMENT PARA 'Data'
  MESSAGE1 DB 'ENTER INITIAL OF FIRST NAME: ','$'
  MESSAGE2 DB 0DH,0AH, 'ENTER INITIAL OF MIDDLE NAME: ','$'
  MESSAGE3 DB 0DH,0AH,'ENTER INITIAL OF LAST NAME: ', '$'
  OUT1 DB 0DH,0AH, 'Initial of your first name is ',  '$'
  CHAR1 DB ?
  OUT2 DB ', middle name is'
  CHAR2 DB ?
  MESSAGE6 DB ' , and last name is '
  CHAR3 DB ? , '!!$'
  INPUT DB ?, "$"
DATASEG ENDS
;---------------------------------------------
CODESEG SEGMENT PARA 'Code'
  ASSUME SS:STACKSEG, DS:DATASEG, CS:CODESEG
START:
  ;set DS to correct dataseg
  MOV AX, DATASEG
  MOV DS, AX
;----------------------------------------------
MAIN PROC FAR

  MOV AX, OFFSET MESSAGE1
  PUSH AX
  CALL GET_INPUT
  MOV AL, INPUT
  MOV CHAR1, AL

  MOV AX, OFFSET MESSAGE2
  PUSH AX
  CALL GET_INPUT
  MOV AL, INPUT
  MOV CHAR2, AL

  MOV AX, OFFSET MESSAGE3
  PUSH AX
  CALL GET_INPUT
  MOV AL, INPUT
  MOV CHAR3, AL

  MOV AX, OFFSET CHAR1
  PUSH AX
  MOV BX, OFFSET CHAR2
  PUSH BX
  MOV DX, OFFSET CHAR3
  PUSH DX

  CALL DISPLAY

  ;terminate
  JMP EXIT

MAIN ENDP
;----------------------------------------------
;input proc
GET_INPUT PROC NEAR

  PUSH BP
  MOV BP, SP

  MOV DX, [BP+4]
  MOV AH, 09H
  INT 21H

  MOV AH, 10H
  INT 16H
  MOV INPUT, AL

  LEA DX, INPUT
  MOV AH, 09H
  INT 21H

  POP BP

  RET
GET_INPUT ENDP
;----------------------------------------------
;display proc
DISPLAY PROC

  PUSH BP
  MOV BP, SP

  LEA DX, OUT1
  MOV AH, 09H
  INT 21H

  MOV DX, [BP+08H]
  MOV AH, 09H
  INT 21H

  POP BP

  RET
DISPLAY ENDP
;----------------------------------------------
EXIT:
  ;terminate; return; exit
  MOV AH, 4CH
  INT 21H

CODESEG ENDS
END START
