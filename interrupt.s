
.equ PS_2, 0xFF200100 #controller 1
.equ LED, 0xFF200000
.equ SEVEN_SEG_DISPLAY_0TO3, 0xFF00020
.equ SEVEN_SEG_DISPLAY_4TO5, 0x10000030
.equ PUSHBUTTONS, 0xFF200050

.equ CODE_UP, 0x1D
.equ CODE_LEFT, 0x1C
.equ CODE_RIGHT, 0x23
.equ CODE_DOWN, 0x1B

.section .exceptions, "ax"

HANDLER:

addi sp, sp, -16
    stw ra, 0(sp)    
    stw r16, 4(sp)
    stw r17, 8(sp)
    stw r18, 12(sp)

rdctl et, ctl4
andi et, et, 0x2
bne et, r0, pushButtonInterrupts

pushButtonInterrupts:
	
	movia r16, PUSHBUTTONS
	
	ldwio r17, 12(r16)
	andi r17, r17, 0b11
	movi r18, 0b10 #Auto Mode 
	beq r17, r18, CHANGE_AUTO
	movi r18, 0b01 #Manual mode (Also Default)
	beq r17, r18, CHANGE_MANUAL
	br CHECK_AUTO

CHANGE_AUTO:
	call hex_auto
	movi r23, 2
	br CHECK_AUTO

CHANGE_MANUAL:
	call hex_manual
	movi r23, 1
	br CHECK_AUTO

CHECK_AUTO:
	movi r17, 0b11
	stwio r17, 12(r16)
	movi r16, 1
	bne r23, r16, DONE #If auto mode, then leave

	movia r16, PS_2
	ldwio r17, 0(r16) #Load PS/2 Data
	andi r17, r17, 0xFF #Mask the other values

	movia r18, CODE_UP #Go Forward
	beq r17, r18, FORWARD
	movia r18, CODE_LEFT #Turn Left
	beq r17, r18, LEFT 
	movia r18, CODE_RIGHT #Turn Right
	beq r17, r18, RIGHT
	movi r18, CODE_DOWN
	beq r17, r18, BACK

#If none selected, motor will stop
STOP:
	movi r4, 6 #parameter for stop
	call motor_function
	br DONE

LEFT:
	movi r4, 1 #Left parameter
	call motor_function
	br DONE

RIGHT:
	movi r4, 3 #Right parameter
	call motor_function
	br DONE

FORWARD:
	mov r4, r0 #Parameter for going straight
	call motor_function
	br DONE
	
BACK:
	movi r4, 2
	call motor_function
	br DONE	

DONE:
	ldw ra, 0(sp)
    ldw r16, 4(sp)
    ldw r17, 8(sp)
    ldw r18, 12(sp)
    addi sp, sp, 16

	addi ea, ea, -4
	eret
