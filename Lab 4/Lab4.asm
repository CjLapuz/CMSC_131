TITLE LOOP LETTERS AND NUMBERS (.EXE MODEL/FORMAT)
;---------------------------------------------
STACKSEG SEGMENT PARA 'Stack'
STACKSEG ENDS
;---------------------------------------------
DATASEG SEGMENT PARA 'Data'
  SPACE DB " ", "$"
  DIGIT DB "Digits: ", "$"
  UPPER DB 10, 13, "Upper Case: ", "$"
  LOWER DB 10, 13, "Lower Case: ", "$"
DATASEG ENDS
;---------------------------------------------
CODESEG SEGMENT PARA 'Code'
  ASSUME SS:STACKSEG, DS:DATASEG, CS:CODESEG
START:
  MOV AX, DATASEG
  MOV DS, AX

  ;set counter to number of digits
  MOV CX, 10

  ;set to 0 in ascii
  MOV AL, 30H

  ;display digit template
  MOV AH, 09
  LEA DX, DIGIT
  INT 21H

  LOOPS:
    ; print current character
    MOV AH, 02
    MOV DL, AL
    INT 21H

    ; space
    MOV AH, 09
    LEA DX, SPACE
    INT 21H

    ; next character in ascii
    INC AL

    LOOP LOOPS

  CMP AL, '['
  JE LOWERS

  CMP AL, 'z'
  JA EXIT

  ; set values for upper letters
  UPPERS:
    ;set counter to number of digits
    MOV CX, 26
    ;set to 'A' in ascii
    MOV AL, 41H

    ;display uppercase letters template
    MOV AH, 09
    LEA DX, UPPER
    INT 21H
    CMP AL, 9
    JMP LOOPS

  ; set values for lower letters
  LOWERS:
    ;set counter to number of digits
    MOV CX, 26
    ;set to 'a' in ascii
    MOV AL, 61H

    ;display lowercase letters template
    MOV AH, 09
    LEA DX, LOWER
    INT 21H
    JMP LOOPS

EXIT:
  MOV AH, 4CH
  INT 21H
CODESEG ENDS
END START
