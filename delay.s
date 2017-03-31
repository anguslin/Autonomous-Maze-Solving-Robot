.equ PERIOD, 10000000								# Set the period to be 262150 clock cycles 
.equ TIMER, 0xFF202000

.global delay

delay:
	
	addi sp, sp, -8
	stw r16, 0(sp)
	stw r17, 4(sp)
	
    movia r16, TIMER                   			# r16 contains the base address for the timer
    
    #mov r17, %lo(r4) 
    #stwio r17, 8(r16)                          
    #mov r17, %hi(r4)
    #stwio r17, 12(r16)
	
	sthio r4, 8(r16)
	srli r4, r4, 4
	stwio r4, 12(r16)

	stwio r0, 0(r16)
    movui r17, 4
    stwio r17, 4(r16)                          # Start the timer without continuing or interrupts 
  

    br _timer_delay

_timer_delay:

	ldwio r17, 0(r16)
    andi r17,r17, 0x1
    beq r17, r0, _timer_delay

	ldw r16, 0(sp)
	ldw r17, 4(sp)
	addi sp, sp, 8
	
	
ret


    
	