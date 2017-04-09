.equ HEX0TO3, 0xFF200020
.equ HEX4TO5, 0xFF200030

.global hex_manual

hex_manual:

	addi sp, sp, -8
	stw r8, 0(sp)
	stw r9, 4(sp)
	
	#HEX code to write FINISH
	movia r8, HEX0TO3
	movia r9, 0b00110111001100000110110101110110
	stwio r9, 0(r8)
	movia r8, HEX4TO5
	movia r9, 0b0111000100110000 
	stwio r9, 0(r8)

	ldw r9, 0(sp)
	ldw r8, 4(sp)
	addi sp, sp, 8
ret
