.global get_sensor_state 

.equ THRESHOLD, 0x0000000b #Adjustable

get_sensor_state:
	addi sp, sp, -4 #Store Return Address
	stw ra, 0(sp)
	.equ ADDR_JP1, 0xFF200060 #Address GPIO JP1

#Get Sensor values
	call get_sensor_val #Get all sensor in value mode
	mov r8, r2 
	movia r9, 0x000FFFFF
	and r8, r8, r9 #Should only be 20 bits but mask the rest in case
	
#Initializing values for converting sensor loop
	mov r9, r8 #Store current sensor vals	
	movia r10, THRESHOLD
	movi r13, 4 #Loop 5 times, one for each sensor	

convert_sensor_loop
	andi r8, r8, 0x0F #Keep the first 4 bits
	bge r8, r10, black_detected #Check if Sensor val is >= threshold
#If not >= threshold, than it is a 0
	mov r11, r0 
	br convert_sensor
#If >= threshold, than set as 1
black_detected:
	movi r11, 0b01

#r12 stores the sensor vals in state mode (on/off) -> Each bit represents one sensor
convert_sensor:  
	or r12, r11 #Change the least significant bit without affecting the other vals
	beq r13, r0, br done_conversion #On last loop
	slli r12, 1 #Shift 1 bit to prepare for next sensor state val
	srli r9, 4 #Shift 4 bits to read the next sensor
	mov r8, r9 #Restore all sensor vals other than the one just converted
	addi r13, -1 #Delete one from the loop counter
	br convert_sensor_loop

done_conversion:
	mov r2, r13
ret 
