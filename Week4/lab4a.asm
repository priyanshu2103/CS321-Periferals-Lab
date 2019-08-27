cpu "8085.tbl"
hof "int8"

org 9000h


RDKBD: EQU 03BAH

MVI A,8BH
OUT 43H

INIT:

MVI A,01H
STA 8000H

IN 41H
ANI 04H
JZ END
IN 41H
ANI 40H
JNZ INIT
IN 41H
ANI 20H
JZ INIT

START:

IN 41H
ANI 04H
JZ END
LDA 8000H
OUT 40H
RLC
STA 8000H
CALL DELAY

IN 41H
ANI 20H
CPI 0H
JZ INIT
JMP START


DELAY: 							;delays machine by 1 second
	MVI C,03H
OUTLOOP:
	LXI H,0A604H
INLOOP: 						;reapeatedly run inloop as many times as
	DCX H 						;frequency of microprocessor
	MOV A,H
	ORA L
	JNZ INLOOP
	DCR C
	JNZ OUTLOOP
	RET

END:	
RST 5

