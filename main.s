.global _start

_start:

.equ ADDR_JP1, 0xFF200060 # Address GPIO JP1
.equ PUSHBUTTONS, 0xFF200050
.equ IRQ_PUSHBUTTONS, 0x02 #Change this
.equ PS_2, 0xFF200100 #controller 1

movia r16, ADDR_JP1

movia sp, 0x7FFFFFFF #Stack Pointer initilization

movia  r17, 0x07F557FF #Set direction for motors to all output 
stwio  r17, 4(r16)

movia r17, 0xFFFAABFF #Set all sensors on and turn motors off
stwio r17, 0(r16)

#Interrupt Setup for pushbuttons
movia r16, PUSHBUTTONS
movia r17, 0b011
stwio r17, 8(r16) #Enable Interrpts on buttons 0 and 1
stwio r0, 12(r16) #Clear edge capture register to prevent unexpected interrupts

#movia r16, IRQ_PUSHBUTTONS
#wrctl ctl3, r16 #Enable bit 1 - Pushbuttons use IRQ 1
#movi r16, 1
#wrctl ctl0, r16 #Enable global Interrupts on processor

#Interrupt Setup for PS/2
#movia r16, PS_2
#movi r17, 1
#stwio r17, 4(r16) #Enable Interrupts for PS/2

movi r17, 0x02 #IRQ bit 7
wrctl ctl3, r17
movi r17, 1
wrctl ctl0, r17 #PEI Bit

mov r23, r0 #   Initialize to 0 

MANUAL_AND_BEGIN_MODE:
	#movi r4, 6 #parameter for stop
	#call motor_function
	
	beq r23, r0, MANUAL_AND_BEGIN_MODE #Initial
	movi r11, 1
	beq r23, r11, MANUAL_AND_BEGIN_MODE #Manual Mode 

#Auto Mode
AUTO_MODE:
	mov r4, r10 #Previous state of the motors
	call decide_direction
	mov r10, r2 #The state of the motors during the call
	movi r11, 2 #Check if still in auto mode
	
	
	beq r23, r0, AUTO_MODE #Initial
	bne r23, r11, MANUAL_AND_BEGIN_MODE
	br AUTO_MODE

	end:
br end
