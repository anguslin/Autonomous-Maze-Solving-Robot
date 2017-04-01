#sensor 4 = *|||| sensor 3 = |*||| sensor 2 = ||*|| sensor 1 = |||*| sensor 0 = ||||* (yellow lego piece)

#Note: The reason we need a move forward one inch subroutine is because of 3 scenarios: 
#Scenario 1) You are at an intersection but the only path you can take is a left turn, you would not record the turn you took as it is not technically an intersection. This is specifically important for implementing part 2 of the maze algorithm where you can take the shortest path and where you have to modify the intersections you took, and you cannot place turns like these in the path
#Scenario 2) When going through the second maze using the shortest turn, when we meet intersections that has only one path, you would not read from the memory of paths to take
#Scenario 3) Since we are using left hand rule, we need to make that we take straight turns prior to right ones, which would require moving forward to check

.global decide_direction

#Motor Function parameters
.equ GOSTRAIGHT, 0
.equ ADJUSTHARDLEFT, 1
.equ TURNAROUND, 2 
.equ ADJUSTHARDRIGHT, 3 
.equ ADJUSTLEFT, 4
.equ ADJUSTRIGHT, 5
.equ STOP, 6
.equ TURNLEFT, 7
.equ TURNRIGHT, 8

decide_direction:
	addi sp, sp, -4 #Store Return Address
	stw ra, 0(sp)
	
	.equ ADDR_JP1, 0xFF200060 #Address GPIO JP1
	movia r8, ADDR_JP1  
	
	#Contains the previous values of the Motor Function parameters
	mov r11, r4

	call get_sensor_state
	mov r8, r2 #Contains current sensor states

		
	#All sensors On
#	movi r9, 0b11111
#	beq r8, r9, left_right_int #Need to check if can go straight
	#Left sensors on
#	movi r9, 0b11100 
#	beq r8, r9, left_int #Need to check if can go straight
	#Right sensors on
#	movi r9, 0b00111 
#	beq r8, r9, right_int #Need to check if can go straight
	
	
	#Left or Right sensor on
	movi r9, 0b10001
	and r9, r9, r8
	bne r9, r0, intersection	

	#Sensor State 2
	movi r9, 0b00100 
	beq r8, r9, move_forward
	#No sensors on
	movi r9, 0b00000 
	beq r8, r9, move_forward
	#Adjust left vals
	movi r9, 0b01000 
	beq r8, r9, adjust_left
#	movi r9, 0b10000
#	beq r8, r9, adjust_left
	movi r9, 0b01100
	beq r8, r9, adjust_left
#	movi r9, 0b11000
#	beq r8, r9, adjust_left
	#Adjust right vals
	movi r9, 0b00010 
	beq r8, r9, adjust_right
#	movi r9, 0b00001
#	beq r8, r9, adjust_right
	movi r9, 0b00110
	beq r8, r9, adjust_right
#	movi r9, 0b00011
#	beq r8, r9, adjust_right
	br previous_state

previous_state:
	#Check if it is turning left, right or around
	movi r12, TURNLEFT 
	beq r11, r12, left_only
	movi r12, TURNRIGHT
	beq r11, r12, right_only
	movi r12, TURNAROUND
	beq r11, r12, u_turn

	#Otherwise call motor function
	mov r4, r11 #Get previous value 
	call motor_function
	mov r2, r11 
	br direction_decided	

#If none of the cases, then stop the motor
stop_motor: #Should only use this when maze is finished, but if no sensor conditions satisfied, it could come use this 
	movi r4, STOP #Parameter for stop motor
	call motor_function
	movi r2, STOP 
	br direction_decided

#Sensor 2 on only 
move_forward: 
	movi r4, GOSTRAIGHT
	call motor_function
	movi r2, GOSTRAIGHT
	br direction_decided
	
#Left or right sensors on 	
intersection:
	call intersection_movement
	mov r10, r2
	andi r13, r10, 0b10001
	movi r9, 0b10001
	beq r13, r9, left_right_int
	movi r9, 0b10000
	beq r13, r9, left_int
	movi r9, 0b00001
	beq r13, r9, right_int			
	
	
#At intersection with left and right paths, need to check if there is a straight path 
left_right_int: 
#Scenario 1: left and right paths only 
#Scenario 2: left, right, and straight paths
#Scenario 3: Finish Line

	call get_sensor_state
	mov r10, r2
	movi r9, 0b11111 #All sensors on
	beq r10, r9, finish_maze
	movi r9, 0b00000 #No straight path
	beq r10, r9, left_right_only
	br left_right_straight

	#Left, right, and straight path intersection
	left_right_straight:
	#If at a left right, and straight intersection, take the left
		call full_left_movement	
		movi r2, TURNLEFT 
		br direction_decided	

	#Left and right path intersection
	left_right_only:
	#If at a left and right intersection, take the left
		call full_left_movement	
		movi r2, TURNLEFT 
		br direction_decided

	#Done maze	
	finish_maze:
	movi r4, STOP #Parameter for stop motor
	call motor_function
	movi r2, STOP
	br direction_decided

#At intersection with left path, need to check if there is a straight path
left_int: 
#Scenario 1: left path only
#Scenario 2: left and straight path
	
	call get_sensor_state
	mov r10, r2
	movi r9, 0b00000 #No straight path
	beq r10, r9, left_only
	br left_straight

	#Left and straight path intersection
	left_straight:
	#If at left and straight intersection, take the left
		call full_left_movement	
		movi r2, TURNLEFT 
		br direction_decided

	#Left path only
	left_only:
	#Take the left	
		call full_left_movement	
		movi r2, TURNLEFT 
		br direction_decided

#At intersection with right path, need to check if there is a straight path
right_int:
#Scenario 1: Right path only
#Scenario 2: right and straight path

	call get_sensor_state
	mov r10, r2
	movi r9, 0b00000 #No straight path
	beq r10, r9, right_only
	br right_straight

	#Right and straight path intersection
	right_straight:
	#If at right and straight intersection, go straight
	movi r4, GOSTRAIGHT 
	call motor_function
	movi r2, GOSTRAIGHT
	br direction_decided

	#Right path only
	right_only:
	#If at right, go right
		call full_right_movement
		movi r2, TURNRIGHT
		br direction_decided

#No sensors on, so it must be at a dead end
u_turn:
#Turn around
	movi r4, TURNAROUND
	call motor_function
	movi r2, TURNAROUND
	br direction_decided

#Straying to the left, so adjust the robot right
adjust_right:
	movi r4, ADJUSTHARDRIGHT
	call motor_function
	movi r2, ADJUSTHARDRIGHT
	br direction_decided

#Straying to the right, so adjust the robot left
adjust_left:
	movi r4, ADJUSTHARDLEFT 
	call motor_function
	movi r2, ADJUSTHARDLEFT
	br direction_decided

#Direction is decided and return from subroutine
direction_decided:
	ldw ra, 0(sp)
	addi sp, sp, 4

ret
