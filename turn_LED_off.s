.equ LEDS, 0xff200000

.global turn_LED_off

turn_LED_off:

	addi sp, sp, -8
	stw r8, 0(sp)
	stw r9, 4(sp)
	
	movia r8, LEDS
	movia r9, 0x00000000 #Turn all LEDs off
	stwio r9, 0(r8) 
	
	ldw r9, 0(sp)
	ldw r8, 4(sp)
	addi sp, sp, 8
ret