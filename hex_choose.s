.equ HEX0TO3, 0xFF200020
.equ HEX4TO5, 0xFF200030

.global hex_choose

hex_choose:

	addi sp, sp, -8
	stw r8, 0(sp)
	stw r9, 4(sp)
	
	#HEX code to write CHOOSE
	movia r8, HEX0TO3
	movia r9, 0b00111111001111110110110101111001
	stwio r9, 0(r8)
	movia r8, HEX4TO5
	movia r9, 0b0011100101110110 
	stwio r9, 0(r8)

	ldw r9, 0(sp)
	ldw r8, 4(sp)
	addi sp, sp, 8
ret
