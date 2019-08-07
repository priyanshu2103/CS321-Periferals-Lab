cpu "8085.tbl"
hof "int8"

org 9000h

;;Code for 16 bit processor

LDA 8004H
CPI 0H
JZ L1
CPI 1H
JZ L2
CPI 2H
JZ L3

CPI 3H
JZ L4



;; ADDITION ANSWER is in  H L 

L1:
LHLD 8000H
XCHG
LHLD 8002H
DAD D
JMP L50



;; SUBTRACTION ANSWER is in HL 

L2:
LHLD 8000H
XCHG 
LHLD 8002H
MOV A, E
SUB L
MOV L, A
MOV A, D
SBB H
MOV H, A
JMP L50



;; Multiplication's ANSWER is in  8100 8101 8102 8103 

L3:
MVI H, 0H
MVI L, 0H
SHLD 8102H
SHLD 8100H



LHLD 8000H

XCHG
;;First operator in DE
LHLD 8002H
MOV C, L
MOV B, H
;; Second operator in BC
MVI L, 0H 
MVI H, 0H
MOV A, E
L6:
CPI 0H
;; end calulation if 0
JZ L7

DAD B
JC L20
L21:
DCR A
JMP L6
L7:
MOV A, D
CPI 0H
JZ L49
DCR D
DAD B
SHLD 8100H
JC L22
L23:
; if the higher order bytes becomes 0, the left number is times is FF H 
MVI A, 0FFH
JMP L6

L20:
; handles 16 to 32 bits of the answers
SHLD 8100H
LHLD 8102H
INX H
SHLD 8102H
LHLD 8100H
JMP L21


L22:
; handles 16 to 32 bits of the answers
SHLD 8100H
LHLD 8102H
INX H
SHLD 8102H
LHLD 8100H
JMP L23




;; DIVISION  ANSWER is in BC


L4:
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
; subtract with borrow
SBB H
MOV D,A
INX B
JMP L13
L12:
MOV A,E
CMP L
JC L11
JMP L15




L49:
; to store the final answer
SHLD 8100H


L11:
L50:

RST 5
