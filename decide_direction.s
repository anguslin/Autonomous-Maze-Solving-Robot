#sensor 0 = *|||| sensor 1 = |*||| sensor 2 = ||*|| sensor 3 = |||*| sensor 4 = ||||*

#Note: The reason we need a move forward one inch subroutine is because of 3 scenarios: 
#Scenario 1) You are at an intersection but the only path you can take is a left turn, you would not record the turn you took as it is not technically an intersection. This is specifically important for implementing part 2 of the maze algorithm where you can take the shortest path and where you have to modify the intersections you took, and you cannot place turns like these in the path
#Scenario 2) When going through the second maze using the shortest turn, when we meet intersections that has only one path, you would not read from the memory of paths to take
#Scenario 3) Since we are using left hand rule, we need to make that we take straight turns prior to right ones, which would require moving forward to check

if(sensor 2 is on) #normal line
#move forward

else if(all sensors on) #At intersection 

#Scenario 1: left and right paths only 
#Scenario 2: left, right, and straight paths
#Scenario 3: Finish Line

	#move forward an inch 
	if(only sensor 2 is on)
		#Must be at Scenario 1
	else if (if no sensor on)
		# must be at Scenario 2 
	else if (all sensors on)
		#must be done maze because the finish line will be a block of black
	else
	#should not come to this scenario?

else if(sensor 0, sensor 1, and sensor 2 is on)  #At intersection
#Scenario 1: left path only
#Scenario 2: left and straight path

	#Call move forward one inch subroutine

else if(sensor 2, sensor 3, and sensor 4 is on) #At intersection
#Scenario 1: Right path only
#Scenario 2: right and straight path

	#Call move forward one inch subroutine

else if(no sensors on) #U turn

	#Call U Turn Subroutine

else if (sensor 1 is on OR 
sensor 0 is on OR 
sensor 0 and sensor 1 is on OR 
sensor 1 and sensor 2 is on) #Off track, straying to the right
	#Call Adjust left subroutine

else if (sensor 3 is on OR 
sensor 4 is on OR 
sensor 3 and sensor 4 is on OR
sensor 3 and sensor 2 is on) #Off track, straying to the left 
	#Call Adjust right subroutine

.global decide_direction

.equ THRESHOLD, 0x0000000b #Adjustable
.equ ADDR_JP1, 0xFF200060 #Address GPIO JP1
movia r8, ADDR_JP1  

decide_direction:

addi sp, sp, -4
stw r10, 0(sp)

movi r4, 0
call sensor_val
mov r9, r2 #get the value for sensor 0

mov r10, r0 #Empty initially 
mov r10, r9 #Register 10 stores the sensor data
andi r9, r9, 0x000F
 
addi sp, sp, -4
stw r10, 0(sp)
 
movi r4, 1
call sensor_val
mov r9, r2 #Get the value for sensor 0
andi r9, r9, 0x000F #Should only be one byte but mask the rest in case
slli r9, 4 #Shift sensor 1 data into bits 4:7
ori r10, r10, r9 #or bits to change bits 4:7 into sensor 1 data but keep sensor 0 data

movi r4, 2
call sensor_val
mov r9, r2 #get the value for sensor 0

movi r4, 3
call sensor_val
mov r9, r2 #get the value for sensor 0

movi r4, 4
call sensor_val
mov r9, r2 #get the value for sensor 0

