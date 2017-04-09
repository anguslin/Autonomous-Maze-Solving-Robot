.equ LEDS, 0xff200000

.global display_LED

display_LED:

	addi sp, sp, -8
	stw r8, 0(sp)
	stw r9, 4(sp)
	
	movia r8, LEDS
	movia r9, 0x000003FF #Turn all LEDs on
	stwio r9, 0(r8) 
	
	ldw r9, 0(sp)
	ldw r8, 4(sp)
	addi sp, sp, 8
ret