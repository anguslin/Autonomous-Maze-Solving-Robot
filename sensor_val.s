.global sensor_val

sensor_val:

.equ ADDR_JP1, 0xFF200060 # Address GPIO JP1
movia r8, ADDR_JP1  

ldw r11, 0(r8) #Get current bits 

#Store sensor enabling bits into the GPIO depending on sensor selected
sensor0:
	movi r9, 0 #Check input parameter
	bne r4, r9, sensor1
	movia r10, 0xFFFFFBFF #Enable sensor 0
	movia r14, 0x00055000 #Disable other sensors
	br sensor_loop

sensor1: 
	movi r9, 1
	bne r4, r9, sensor2
	movia r10, 0xFFFFEFFF #Enable sensor 1
	movia r14, 0x00054400 #Disable other sensors
	br sensor_loop

sensor2:
	movi r9, 2
	bne r4, r9, sensor3
	movia r10, 0xFFFFBFFF #Enable sensor 2 
	movia r14, 0x00051400 #Disable other sensors
	br sensor_loop

sensor3:
	movi r9, 3
	bne r4, r9, sensor4
	movia r10, 0xFFFEFFFF #Enable sensor 3
	movia r14, 0x00045400 #Disable other sensors
	br sensor_loop

sensor4: #If not 0,1,2,3, the sensor must be 4 unless, incorrect input parameter
	movi r9, 4
	movia r10, 0xFFFBFFFF #Enable sensor 4
	movia r14, 0x00015400 #Disable other sensors
	br sensor_loop

#Start sensor loop
sensor_loop: 
	and r11, r11, r10 #Enabling specified sensor without changing existing GPIO values
	or r11, r11, r14 #Disabling sensors other than specified one
	stwio r11, 0(r8) #Store the GPIO bits to enable the speciFied sensor

sensor_loop_poll: #Poll until the sensor value is valid and can be read
	ldwio  r12,  0(r8) #Load the GPIO to check the valid/notvalid sensor data bit  

sensor0_check:
	movi r9, 0
	bne r4, r9, sensor1_check  
	srli r13, r12, 11 #Bit 11 is valid bit For sensor 0 
	br sensor_check_done

sensor1_check:
	movi r9, 1
	bne r4, r9, sensor2_check  
	srli r13, r12, 13 #Bit 13 is valid bit For sensor 0 
	br sensor_check_done

sensor2_check:
	movi r9, 2
	bne r4, r9, sensor3_check  
	srli r13, r12, 15 #Bit 15 is valid bit For sensor 0       
	br sensor_check_done

sensor3_check:
	movi r9, 3
	bne r4, r9, sensor4_check  
	srli r13, r12, 17 #Bit 17 is valid bit For sensor 0       
	br sensor_check_done

sensor4_check:
	movi r9, 4 #If not 0,1,2,3, the sensor must be 4 unless, incorrect input parameter
	srli r13, r12, 19 #Bit 19 is valid bit For sensor 0       

sensor_check_done:
	andi r13, r13, 0x1 #Change all bits other than the sensor valid bit to 0
	bne r0, r13, sensor_loop_poll #Wait For sensor valid to be 0 -> bit 0

get_sensor_val:
	srli r12, r12, 27  #ShiFt to the right by 27 bits so that 4-bit sensor value is in lower 4 bits 
	andi r12, r12, 0x0F #Change all bits other than the 4 display vits into 0

	mov r2, r12 #Move the display bits into return register
ret

