TITLE ASM1 (.EXE MODEL)
;---------------------------------------------
STACKSEG SEGMENT PARA 'Stack'
STACKSEG ENDS
;---------------------------------------------
DATASEG SEGMENT PARA 'Data'
  LINE1  DB  '   * * * * * *  * ** ** ** *     *                *',0DH,0AH,'$'
  LINE2  DB  '         *      *                **              **',0DH,0AH,'$'
  LINE3  DB  '         *      *                *  *           * *',0DH,0AH,'$'
  LINE4  DB  '         *      *                *   *         *  *',0DH,0AH,'$'
  LINE5  DB  '         *      * ** ** **       *    *       *   *',0DH,0AH,'$'
  LINE6  DB  '         *      *                *     *     *    *',0DH,0AH,'$'
  LINE7  DB  '        *       *                *      *   *     *',0DH,0AH,'$'
  LINE8  DB  '  *    *        *                *       * *      *',0DH,0AH,'$'
  LINE9  DB  '     *          * ** ** ** *     *        *       *',0DH,0AH,'$'
DATASEG ENDS
;---------------------------------------------
CODESEG SEGMENT PARA 'Code'
  ASSUME SS:STACKSEG, DS:DATASEG, CS:CODESEG
START:
  ;set DS to correct dataseg
  MOV AX, DATASEG
  MOV DS, AX

  LEA DX, LINE1
  MOV AH, 09
  INT 21H

  LEA DX, LINE2
  MOV AH, 09
  INT 21H

  LEA DX, LINE3
  MOV AH, 09
  INT 21H

  LEA DX, LINE4
  MOV AH, 09
  INT 21H

  LEA DX, LINE5
  MOV AH, 09
  INT 21H

  LEA DX, LINE6
  MOV AH, 09
  INT 21H

  LEA DX, LINE7
  MOV AH, 09
  INT 21H

  LEA DX, LINE8
  MOV AH, 09
  INT 21H

  LEA DX, LINE9
  MOV AH, 09
  INT 21H

  ;terminate; return; exit
  MOV AH, 4CH
  INT 21H
CODESEG ENDS
END START
