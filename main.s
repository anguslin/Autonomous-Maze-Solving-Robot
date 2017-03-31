.global _start

_start:

.equ ADDR_JP1, 0xFF200060 # Address GPIO JP1
movia r8, ADDR_JP1

movia sp, 0x7FFFFFFF #Stack Pointer initilization

movia  r9, 0x07F557FF #Set direction for motors to all output 
stwio  r9, 4(r8)

movia r17, 0xFFFAABFF #Set all sensors on and turn motors off
stwio r17, 0(r8)

read_sensor_and_decide_direction:
	mov r4, r10 #Previous state of the motors
	call decide_direction
	mov r10, r2 #The state of the motors during the call
	br read_sensor_and_decide_direction

end:
br end
