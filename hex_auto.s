.equ HEX0TO3, 0xFF200020
.equ HEX4TO5, 0xFF200030

#HEX code to write AUTO 
movia r8, HEX0TO3
movia r9, 0b 01110111 00111110 01111000 00111111
stwio r9, 0(r8)
movia r8, HEX4TO5
stwio r0, 0(r8)


