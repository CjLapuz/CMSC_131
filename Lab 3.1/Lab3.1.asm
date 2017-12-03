TITLE JMP SIGNED (EXE)
;---------------------------------------------
STACKSEG SEGMENT PARA 'Stack'
STACKSEG ENDS
;---------------------------------------------
DATASEG SEGMENT PARA 'Data'
  TEMP_READING DW 65263

  A_ALERT DB "Too Hot! Give yourself a shower.$"
  B_ALERT DB "You're Good. Stay Alert.$"
  C_ALERT DB "Oh no! You're freezing.$"
DATASEG ENDS
;---------------------------------------------
CODESEG SEGMENT PARA 'Code'
  ASSUME SS:STACKSEG, DS:DATASEG, CS:CODESEG
START:

  ;set DS correctly
  MOV AX, DATASEG
  MOV DS, AX

  ; OVERHEAT
  OVERHEAT_CHECK:
    MOV SI, TEMP_READING
    CMP SI,80
    JGE IS_HOT


  FROST_CHECK:
    CMP SI, 30
    JLE IS_COLD
    JMP IS_OKAY

  IS_HOT:
    MOV AH, 09
    LEA DX, A_ALERT
    INT 21H
    JMP EXIT

  IS_OKAY:
    MOV AH, 09
    LEA DX, B_ALERT
    INT 21H
    JMP EXIT

  IS_COLD:
    MOV AH, 09
    LEA DX, C_ALERT
    INT 21H
    JMP EXIT

EXIT:
  MOV AH, 4CH
  INT 21H

CODESEG ENDS
END START
