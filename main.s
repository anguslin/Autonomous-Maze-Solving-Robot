.global _start

_start:

.equ ADDR_JP1, 0xFF200060 # Address GPIO JP1
movia r8, ADDR_JP1

movia sp, 0x7FFFFFFF #Stack Pointer initilization

movia  r9, 0x07F557FF #Set direction for motors to all output 
stwio  r9, 4(r8)

ldwio r16, 0(r8)
movia r17, 0xFFFAABFF #Set all sensors on and motors off
and r16, r16, r17
stwio r16, 0(r8)

call get_sensor_val 

end:
br end




