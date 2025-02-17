cpu "8085.tbl"
hof "int8"

org 9000h

GTHEX: EQU 030EH				;Gets hex digits and stores them in DE register pair

CALL GTHEX
MOV A,D
STA 8003H
MOV A,E
STA 8002H 

MVI A, 80H
OUT 03H


MVI A,8BH
OUT 43H

; Input taken from LIC
; LED16- Triangular wave LED15- Sawtooth wave LED14- Square wave LED13- Staircase wave
; LED12- Symmetric staircase wave LED11- Sine wave
INIT:

IN 41H
CPI 00H
JZ INIT
CPI 01H
JZ TRI
CPI 02H
JZ SAW
CPI 04H
JZ SQU
CPI 08H
JZ STAIR
CPI 10H
JZ STAIRSYMM
CPI 20H
JZ SIN
JMP INIT

; code for generating triangular wave
TRI:
MVI A,5EH
STA 8001H
MVI A,0A1H
STA 8000H
CALL DIV
MOV B,C
; ANS OF DIV IS IN 800AH (LOWER 2 DIGITS)

MVI A, 80H
OUT 03H
XRA A
STA 8800H
L1:

OUT 00H
OUT 01H
LDA 8800H
INR A
STA 8800H
CMP B
JNZ L1
L2:

LDA 8800H
OUT 00H
OUT 01H
DCR A
STA 8800H
JNZ L2
JMP L1

; code for sawtooth wave
SAW:
MVI A,0BDH
STA 8001H
MVI A,42H
STA 8000H
CALL DIV
MOV B,C
; ANS OF DIV IS IN 800AH (LOWER 2 DIGITS)

MVI A, 80H
OUT 03H
XRA A
STA 8800H
L3:

OUT 00H
OUT 01H
LDA 8800H
INR A
STA 8800H
CMP B
JNZ L3
MVI A,00H
STA 8800H
JMP L3

; code for square wave
SQU:
MVI A, 0FFH
OUT 00H
OUT 01H
OUT 40H
CALL DELAY
MVI A,00H
OUT 00H
OUT 01H
OUT 40H
CALL DELAY
JMP SQU

; code for staircase wave
STAIR:
MVI A, 80H
OUT 03H
MVI A,00H
STA 8800H

L7:
LDA 8800H
OUT 00H
OUT 01H
OUT 40H


CALL DELAY2

LDA 8800H
ADI 20H
STA 8800H
CPI 0E0H
JNZ L7
MVI A,00H
STA 8800H
JMP L7

STAIRSYMM:
MVI A, 80H
OUT 03H
MVI A,00H
STA 8800H

L5:
LDA 8800H
OUT 00H
OUT 01H
OUT 40H


CALL DELAY3

LDA 8800H
ADI 20H
STA 8800H
CPI 0E0H
JNZ L5

L6:
LDA 8800H
OUT 00H
OUT 01H
OUT 40H
MVI D,08H

CALL DELAY3

LDA 8800H
SBI 20H
STA 8800H
CPI 00H
JNZ L6
JMP L5

; code for sine wave
SIN:
MVI A,00H
STA 8501H
MVI A,01H
STA 8502H
MVI A,02H
STA 8503H
MVI A,04H
STA 8504H
MVI A,08H
STA 8505H
MVI A,11H
STA 8506H
MVI A,17H
STA 8507H
MVI A,1EH
STA 8508H
MVI A,25H
STA 8509H
MVI A,2DH
STA 850AH
MVI A,36H
STA 850BH
MVI A,40H
STA 850CH
MVI A,49H
STA 850DH
MVI A,54H
STA 850EH
MVI A,5EH
STA 850FH
MVI A,69H
STA 8510H
MVI A,74H
STA 8511H
MVI A,7FH
STA 8512H
MVI A,84H
STA 8513H
MVI A,95H
STA 8514H
MVI A,9FH
STA 8515H
MVI A,0AFH
STA 8516H
MVI A,0B4H
STA 8517H
MVI A,0C0H
STA 8518H
MVI A,0C8H
STA 8519H
MVI A,0D0H
STA 851AH
MVI A,0D8H
STA 851BH
MVI A,0E0H
STA 851CH
MVI A,0EAH
STA 851DH
MVI A,0EDH
STA 851EH
MVI A,0EFH
STA 851FH
MVI A,0F2H
STA 8520H
MVI A,0F9H
STA 8521H
MVI A,0FCH
STA 8522H
MVI A,0FDH
STA 8523H
MVI A,0FFH
STA 8524H
MVI A,00H
STA 8525H

START:
MVI C,24H
LXI H,8501H
POS:
MOV A,M
OUT 00H
OUT 01H
OUT 40H
;OUT 41H
INX H
DCR C
JNZ POS
MVI C,24H
NEG:
DCX H
MOV A,M
OUT 00H
OUT 01H
OUT 40H
OUT 41H
    DCR C
    JNZ NEG
    JMP START

RST 5


DELAY: 	
					
	MVI A,01H
	STA 8005H
OUTLOOP:
	LXI H,3A98H
	SHLD 8000H
	CALL DIV
	;LHLD 8009H
INLOOP: 						;reapeatedly run inloop as many times as
	DCX H 						;frequency of microprocessor
	MOV A,H
	ORA L
	JNZ INLOOP
	LDA 8005H
	DCR A
	STA 8005H
	CPI 00H
	JNZ OUTLOOP
	RET

DELAY2: 	
					
	MVI A,01H
	STA 8005H
OUTLOOP2:
	LXI H,85EH
	SHLD 8000H
	CALL DIV
	;LHLD 8009H
INLOOP2: 						;reapeatedly run inloop as many times as
	DCX H 						;frequency of microprocessor
	MOV A,H
	ORA L
	JNZ INLOOP2
	LDA 8005H
	DCR A
	STA 8005H
	CPI 00H
	JNZ OUTLOOP2
	RET

DELAY3: 	
					
	MVI A,01H
	STA 8005H
OUTLOOP3:
	LXI H,3A9H
	SHLD 8000H
	CALL DIV
	;LHLD 8009H
INLOOP3: 						;reapeatedly run inloop as many times as
	DCX H 						;frequency of microprocessor
	MOV A,H
	ORA L
	JNZ INLOOP3
	LDA 8005H
	DCR A
	STA 8005H
	CPI 00H
	JNZ OUTLOOP3
	RET
DIV:
	LHLD 8000H
	XCHG
	LHLD 8002H
	MVI B, 0H
	MVI C, 0H
	L13:
	MOV A,D
	CMP H
	JC L11
	JZ L12
	L15:
	MOV A,E
	SUB L
	MOV E,A
	MOV A,D
	SBB H
	MOV D,A
	INX B
	JMP L13
	L12:
	MOV A,E
	CMP L
	JC L11
	JMP L15


	L11:
	MOV H,B
	MOV L,C
	SHLD 8009H
	RET