.equ TIMER2, 0xFF202020

.global intersection_movement



intersection_movement:				#initiation
	addi sp, sp, -4
	stw ra, 0(sp)
	
	movia r16, TIMER2                   			# r16 contains the base address for the timer
    
    movi r17, %lo(150000000) 
    stwio r17, 8(r16)                          
    movi r17, %hi(150000000)
    stwio r17, 12(r16)
	
	stwio r0, 0(r16)
    movui r17, 4
    stwio r17, 4(r16)                          # Start the timer without continuing or interrupts 
	
	movi r18, 0
	
	movia r4, 0x500
	call delay
	
	
forward:
	

	movi r4, 0
	call motor_function
	ldwio r17, 0(r16)
    andi r17,r17, 0x1	
	
	call get_sensor_state
	or r18, r18, r2
	
	
    beq r17, r0, forward
	
	movia r4, 0x1000
	call delay
	
	
epilogue:	
	mov r2, r18
	ldw ra, 0(sp)
	addi sp, sp, 4
	
ret

backward_setup:
	movia r16, TIMER2                   			# r16 contains the base address for the timer
    
    movi r17, %lo(500000000) 
    stwio r17, 8(r16)                          
    movi r17, %hi(500000000)
    stwio r17, 12(r16)
	
	stwio r0, 0(r16)
    movui r17, 4
    stwio r17, 4(r16)                          # Start the timer without continuing or interrupts 	
	
backward:
	movi r4, 2
	call motor_function
	ldwio r17, 0(r16)
    andi r17,r17, 0x1
    beq r17, r0, backward
