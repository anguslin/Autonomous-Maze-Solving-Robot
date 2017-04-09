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
movia r17, 0b0111
stwio r17, 8(r16) #Enable Interrpts on buttons 0 and 1 and 2
stwio r0, 12(r16) #Clear edge capture register to prevent unexpected interrupts

#movia r16, IRQ_PUSHBUTTONS
#wrctl ctl3, r16 #Enable bit 1 - Pushbuttons use IRQ 1
#movi r16, 1
#wrctl ctl0, r16 #Enable global Interrupts on processor

#Interrupt Setup for PS/2
movia r16, PS_2
movi r17, 1
stwio r17, 4(r16) #Enable Interrupts for PS/2

movi r17, 0x082 #IRQ bit 7
wrctl ctl3, r17
movi r17, 1
wrctl ctl0, r17 #PEI Bit

mov r23, r0 #   Initialize to 0 

#start mode (state 0)
START_MODE:
	call hex_choose #Display CHOOSE on Seven Seg Display
	beq r23, r0, START_MODE #Initial
	movi r11, 1 #Check if in manual mode
	beq r23, r0, MANUAL_AND_BEGIN_MODE #Initial
	movi r11, 2 #Check if in auto left mode
	beq r23, r11, AUTO_LEFT_MODE
	movi r11, 3 #Check if in finish mode
	beq r23, r11, FINISH_MODE
	movi r11, 4 #Check if in auto right mode
	beq r23, r11, AUTO_RIGHT_MODE
	br START_MODE

#manual mode (state 1)
MANUAL_AND_BEGIN_MODE:
	#movi r4, 6 #parameter for stop
	#call motor_function
		
	beq r23, r0, MANUAL_AND_BEGIN_MODE #Initial
	movi r11, 2 #Check if in auto left mode
	beq r23, r11, AUTO_LEFT_MODE
	movi r11, 3 #Check if in finish mode
	beq r23, r11, FINISH_MODE
	movi r11, 4 #Check if in auto right mode
	beq r23, r11, AUTO_RIGHT_MODE
	br MANUAL_AND_BEGIN_MODE

#Auto left Mode (state 2)
AUTO_LEFT_MODE:
	mov r4, r10 #Previous state of the motors
	call decide_direction
	mov r10, r2 #The state of the motors during the call	
	
	beq r23, r0, AUTO_LEFT_MODE #Initial
	movi r11, 1 #Check if in manual mode
	beq r23, r11, MANUAL_AND_BEGIN_MODE
	movi r11, 3 #Check if in finish mode
	beq r23, r11, FINISH_MODE
	movi r11, 4 #Check if in auto right mode
	beq r23, r11, AUTO_RIGHT_MODE
	br AUTO_LEFT_MODE

#Finish_mode (state 3)
FINISH_MODE:
	call hex_finish #Display FINISH on Seven Seg Display
	call display_LED #Display LEDs at the finish
	beq r23, r0, FINISH_MODE #Initial
	movi r11, 1 #Check if in manual mode
	beq r23, r11, MANUAL_AND_BEGIN_MODE
	movi r11, 2 #Check if in auto left mode
	beq r23, r11, AUTO_LEFT_MODE
	movi r11, 4 #Check if in auto right mode
	beq r23, r11, AUTO_RIGHT_MODE
	br FINISH_MODE

#Auto right Mode (state 4)
AUTO_RIGHT_MODE:
	mov r4, r10 #Previous state of the motors
	call decide_direction_right
	mov r10, r2 #The state of the motors during the call	
	
	beq r23, r0, AUTO_RIGHT_MODE #Initial
	movi r11, 1 #Check if in manual mode
	beq r23, r11, MANUAL_AND_BEGIN_MODE
	movi r11, 2 #Check if in auto left mode
	beq r23, r11, AUTO_LEFT_MODE
	movi r11, 3 #Check if in finish mode
	beq r23, r11, FINISH_MODE
	br AUTO_RIGHT_MODE
	
	end:
br end
