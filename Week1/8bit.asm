cpu "8085.tbl"
hof "int8"

org 9000h

;;Code for 8 bit


;; bring operands from memory location to registers B and C
LDA 8000H
MOV B, A
LDA 8001H
MOV C, A

; bring the operation code to A. The convention is 0 - add, 1 - sub, 2- multiply, 3- division
LDA 8002H
CPI 0H
JZ L1
CPI  1H
JZ L2
CPI 2H
JZ L3
CPI 3H
JZ L9

;;Code for addition


L1: 
MOV A, B
ADC C
JMP L8

;;Code for subtraction

L2:
MOV A, B
SUB C
JMP L8


;;Code for multiplication

L3:
MOV D, B
MOV A, C
MVI E, 0H
L4:
CPI 0H
;; if 0 then quit
JZ L7
L5:
; keep adding C till D becomes 0
MOV A, E
ADD C
DCR D
MOV E, A
MOV A, D
JMP L4
L7:
MOV A, E
JMP L8

;;Code for division

L9:
MOV A, B
MVI D, 0H
L10:
CMP C
JC L11
SUB C
; qoutient
INR D
JMP L10
L11:
; finally, remainder is in B and quotient in A
MOV B, A
MOV A, D
 



L8:






RST 5
