cpu "8085.tbl"
hof "int8"

org 9000H

GTHEX: EQU 030EH				;Gets hex digits and stores them in DE register pair
OUTPUT:EQU 0389H				;Outputs characters to display
CLEAR: EQU 02BEH				;Clears the display
RDKBD: EQU 03BAH

MVI A,00H
STA 8900H         				; 8900 BOOLEAN 00 FOR INTR DISABLE, 01 FOR INTR ENABLE

STA 8901H                       ; FIRST TIME


MVI A,0BH
SIM 
EI

MVI A,00H
MVI B,00H


; 8800 for sec, 8810 for min, 8820 for hr
CALL GTHEX 						
MOV A,D
STA 8820H
MOV A,E
STA 8810H

;L17:
;LDA 8901H
;CPI 00H
;JZ L17

; L3 for coming back to start
L3:
MVI A,00H
STA 8800H
MVI A,01H
STA 8901H
MVI A,00H
CALL SEC



; loop for decrementing seconds
SEC:
CALL PRINT						; prints every second
CALL DELAY
;LDA 8900H
;CPI 01H
;JZ SEC
LDA 8800H
DCR A
STA 8800H
ANI 0FH
CPI 0FH
JNZ L8
LDA 8800H
SBI 06H
STA 8800H
L8:
LDA 8800H
CPI 0F9H							; if seconds become 00, then change minute
JZ MIN
JMP SEC

; loop for decrementing minutes
MIN:
MVI A,59H
STA 8800H
LDA 8810H

DCR A
STA 8810H
ANI 0FH
CPI 0FH
JNZ L9
LDA 8810H
SBI 06H
STA 8810H
L9:
LDA 8810H
CPI 0F9H							; if minutes become 00, then change	hour
JZ HR
JMP SEC

; loop for decrementing hours
HR:
MVI A, 59H
STA 8810H
LDA 8820H

DCR A
STA 8820H
ANI 0FH
CPI 0FH
JNZ L11
LDA 8820H
SBI 06H
STA 8820H
L11:
LDA 8820H
CPI 0F9H           				
JZ RES							; if hours become 00, then end
CALL SEC

RES:
MVI A,0H
STA 8810H
STA 8820H
JMP L12

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

; prints every second
PRINT:

	MVI A,00H 						
	MVI B,00H 						
	; 8840, 8841, 8842  and 8843 for address field

	; for printing every second
	L10:

	MVI B,00H
	LDA 8820H
	ANI 0F0H                     ; taking higher 4 bits
	RRC
	RRC
	RRC
	RRC
	LXI H,8840H		
	MOV M,A

	LDA 8820H			
	ANI 0FH						 ; taking lower 4 bits
	LXI H,8841H
	MOV M,A

	LDA 8810H
	ANI 0F0H
	RRC
	RRC
	RRC
	RRC
	LXI H,8842H
	MOV M,A

	LDA 8810H
	ANI 0FH
	LXI H,8843H
	MOV M,A

	LXI H,8840H
	MVI A, 00H
	CALL OUTPUT					 ; printing address field

	LDA 8800H
	ANI 0F0H
	RRC
	RRC
	RRC
	RRC
	LXI H,8845H
	MOV M,A

	LDA 8800H
	ANI 0FH
	LXI H,8846H
	MOV M,A
	

	
	; 8845  and 8846 for data field
	
	LXI H,8845H
	MVI A, 01H
	CALL OUTPUT					; printing data field
	RET


L12:
RST 5

INTERRUPT:
	PUSH PSW
	CALL RDKBD
	POP PSW
	EI
	RET


