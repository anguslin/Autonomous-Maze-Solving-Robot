.equ TIMER2, 0xFF202020

.global intersection_movement



intersection_movement:				#initiation
	addi sp, sp, -4
	stw ra, 0(sp)
	
	movia r16, TIMER2                   			# r16 contains the base address for the timer
    
    movi r17, %lo(100000000) 
    stwio r17, 8(r16)                          
    movi r17, %hi(100000000)
    stwio r17, 12(r16)
	
	stwio r0, 0(r16)
    movui r17, 4
    stwio r17, 4(r16)                          # Start the timer without continuing or interrupts 

forward:
	movi r4, 0
	call motor_function
	ldwio r17, 0(r16)
    andi r17,r17, 0x1
    beq r17, r0, forward
	
	movia r4, 0x500
	call delay
	
read_sensor_data:
	get_sensor_state
	
backward_setup:
	movia r16, TIMER2                   			# r16 contains the base address for the timer
    
    movi r17, %lo(300000000) 
    stwio r17, 8(r16)                          
    movi r17, %hi(300000000)
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
	
epilogue:	
	ldw ra, 0(sp)
	addi sp, sp, 4
	
ret
