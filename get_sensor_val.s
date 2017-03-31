.global get_sensor_val 

get_sensor_val:

	addi sp, sp, -4 #Store Return Address
	stw ra, 0(sp)
	.equ ADDR_JP1, 0xFF200060 #Address GPIO JP1

#Sensor 0 Data
	movi r4, 0 #Input argument to read sensor 0
	call sensor_val
	mov r8, r2 #Move value for sensor 0 into r8
	andi r8, r8, 0x000F #Should only be 4 bits but mask the rest in case
	mov r9, r0 #Empty initially 
	mov r9, r8 #Register 9 stores the sensor data

#Sensor 1 Data
	addi sp, sp, -4 #Set up stack
	stw r9, 0(sp) #Store r9 into stack
	movi r4, 1 #Input argument to read sensor 1
	call sensor_val
	ldw r9, 0(sp) #Restore r9 from stack
	addi sp, sp, 4 #Move stack pointer down the memory

	mov r8, r2 #Get the value for sensor 1
	andi r8, r8, 0x000F #Should only be 4 bits but mask the rest in case
	slli r8, r8, 4 #Shift sensor 1 data into bits 4:7
	or r9, r9, r8 #Or bits to change bits 4:7 into sensor 1 data but keep sensor 0 data

#Sensor 2 Data
	addi sp, sp, -4 #Set up stack
	stw r9, 0(sp) #Store r9 into stack
	movi r4, 2 #Input argument to read sensor 2
	call sensor_val
	ldw r9, 0(sp) #Restore r9 from stack
	addi sp, sp, 4 #Move stack pointer down the memory

	mov r8, r2 #Get the value for sensor 2
	andi r8, r8, 0x000F #Should only be 4 bits but mask the rest in case
	slli r8, r8, 8 #Shift sensor 2 data into bits 8:11
	or r9, r9, r8 #Or bits to change bits 8:11 into sensor 1 data but keep sensor 0 data

#Sensor 3 Data
	addi sp, sp, -4 #Set up stack
	stw r9, 0(sp) #Store r9 into stack
	movi r4, 3 #Input argument to read sensor 3
	call sensor_val
	ldw r9, 0(sp) #Restore r9 from stack
	addi sp, sp, 4 #Move stack pointer down the memory

	mov r8, r2 #Get the value for sensor 0
	andi r8, r8, 0x000F #Should only be 4 bits but mask the rest in case
	slli r8, r8, 12 #Shift sensor 1 data into bits 12:15
	or r9, r9, r8 #Or bits to change bits 12:15 into sensor 1 data but keep sensor 0 data

#Sensor 4 Data
	addi sp, sp, -4 #Set up stack
	stw r9, 0(sp) #Store r9 into stack
	movi r4, 4 #Input argument to read sensor 1
	call sensor_val
	ldw r9, 0(sp) #Restore r9 from stack
	addi sp, sp, 4 #Move stack pointer down the memory

	mov r8,	r2 #Get the value for sensor 0
	andi r8, r8, 0x000F #Should only be 4 bits but mask the rest in case
	slli r8, r8, 16 #Shift sensor 1 data into bits 16:19
	or r9, r9, r8 #Or bits to change bits 16:19 into sensor 1 data but keep sensor 0 data

#Return the data for the 5 sensors stored inside r9
	mov r2, r9

	ldw ra, 0(sp)
	addi sp, sp, 4
ret
