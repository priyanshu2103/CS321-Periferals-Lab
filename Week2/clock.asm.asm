cpu "8085.tbl"
hof "int8"

org 9000H

GTHEX: EQU 030EH				;Gets hex digits and stores them in DE register pair
OUTPUT:EQU 0389H				;Outputs characters to display
CLEAR: EQU 02BEH				;Clears the display

MVI A,00H
MVI B,00H

; 8830 for hr and 8831 for min of alarm
CALL GTHEX 
MOV A,D   
STA 8830H
MOV A,E
STA 8831H

; 8800 for sec, 8810 for min, 8820 for hr
CALL GTHEX 						
MOV A,D	
STA 8820H
MOV A,E
STA 8810H

; L3 for coming back to start
L3:
MVI A,00H
STA 8800H
CALL SEC

; loop for incrementing seconds
SEC:
CALL PRINT						; prints every second
CALL DELAY
LDA 8800H
INR A
DAA 
STA 8800H
CPI 60H							; if seconds become 60, then change minute
JZ MIN
JMP SEC

; loop for incrementing minutes
MIN:
MVI A,0H
STA 8800H
LDA 8810H
INR A
DAA
STA 8810H
CPI 60H							; if minutes become 60, then change	hour
JZ HR
JMP SEC

; loop for incrementing hours
HR:
MVI A, 0H
STA 8810H
LDA 8820H
INR A
DAA
STA 8820H
CPI 24H           				; 12H for 12 hr clock
JZ RES							; if hours become 24, then reset to 00:00:00
CALL SEC

RES:
MVI A,0H
STA 8810H
STA 8820H
JMP L3
CALL SEC

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

	; alarm check 
	; compare hr
	LDA 8820H
	MOV B,A
	LDA 8830H
	CMP B
	JNZ L10

	;if hr is same then compare min
	LDA 8810H
	MOV B,A
	LDA 8831H
	CMP B
	JNZ L10

	;if min is same then compare sec to 0
	LDA 8800H
	CPI 00H
	JNZ L10 
	; DISP
	CALL CLEAR
	
	; display CLOC in address field
	LXI H,8840H
	MVI M,0CH

	LXI H,8841H
	MVI M,11H

	LXI H,8842H
	MVI M,00H

	LXI H,8843H
	MVI M,0CH

	LXI H,8840H
	MVI A,00H

	CALL OUTPUT
	
	; display for 5 seconds
	CALL DELAY
	CALL DELAY
	CALL DELAY
	CALL DELAY
	CALL DELAY
	
	; reset second to 5 
	MVI A, 05H
	STA 8800H
	
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
RST 5