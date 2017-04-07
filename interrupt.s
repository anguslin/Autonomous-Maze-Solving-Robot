
.equ PS_2, 0xFF200100 #controller 1
.equ LED, 0xFF200000
.equ SEVEN_SEG_DISPLAY_0TO3, 0xFF00020
.equ SEVEN_SEG_DISPLAY_4TO5, 0x10000030
.equ PUSHBUTTONS, 0xFF200050

.equ CODE_G, 0x34
.equ CODE_L, 0x4B
.equ CODE_F, 0x2B
.equ CODE_R, 0x2D
.equ CODE_U, 0x3C
.equ CODE_S, 0x1B

.section .exceptions, "ax"

HANDLER:

movia r16, PUSHBUTTONS
ldwio r17, 0(r19)
andi r17, r17, 0b11
movi r18, 0b01 #Auto Mode 
beq r17, r18, CHANGE_AUTO
movi r18, 0b10 #Manual mode (Also Default)
beq r17, r18, CHANGE_MANUAL
br CHECK_AUTO

CHANGE_AUTO:
	movi r23, 1
	br CHECK_AUTO

CHANGE_MANUAL:
	mov r23, r0
	br CHECK_AUTO

CHECK_AUTO:
	bne r23, r0, DONE #If auto mode, then leave

	movia r16, PS2
	ldwio r17, 0(r16) #Load PS/2 Data
	andi r17, r17, 0xFF #Mask the other values

	movia r18, CODE_F #Go Forward
	beq r17, r18, FORWARD
	movia r18, CODE_L #Turn Left
	beq r17, r18, LEFT 
	movia r18, CODE_R #Turn Right
	beq r17, r18, RIGHT
	movia r18, CODE_U #Turn Around
	beq r17, r18, U_TURN

#If none selected, motor will stop
STOP:

	br DONE

LEFT:

	call full_left_movement	
	br DONE

RIGHT:
	call full_right_movement
	br DONE

FORWARD:
	mov r4, r0 #Parameter for going straight
	call motor_function
	br DONE
	
U_TURN:
	call full_u_turn_movement
	br DONE

DONE:
	addi ea, ea, -44
	eret
