extends KinematicBody2D

var gear = 1

var SPEED_GEAR_1 = 100
var SPEED_GEAR_2 = 200
var speed = SPEED_GEAR_1
var acceleration = 5

var gravity = 0
var GRAVITY_INC = 0.2
var MAX_GRAVITY = 6

var JUMPPOWER = 300

var direction = 1

var on_ground = false

var velocity = Vector2()

func _ready():
	set_process_input(true)
	set_fixed_process(true)
	
func _input(event):
	# Switch gears on user input
	if event.is_action_pressed("ui_interact"):
		switch_gears()
	
func _fixed_process(delta):
	_velocity(delta)
	_move_and_slide(delta)
	
func _velocity(delta):
	"""Handles player velocity and direction based on user input."""
		
	# Horizontal inputs
	var h_in = direction
	if in_second_gear() and on_ground or in_first_gear() :
		h_in = Input.is_action_pressed("ui_right") - Input.is_action_pressed("ui_left")
	# Set direction if moving
	if (h_in != 0): 
		direction = h_in
	if in_second_gear():
		h_in = direction
	
	print(speed)
	# Speed based on gear and input
	if h_in == 0: # While not moving
		if speed > 0: speed -= acceleration
	else: # While moving
		if in_first_gear():
			if speed < SPEED_GEAR_1: speed += acceleration
			elif speed > SPEED_GEAR_1: speed -= acceleration
			speed = max(speed, SPEED_GEAR_1)
		elif in_second_gear():
			if speed < SPEED_GEAR_2: speed += acceleration
			elif speed > SPEED_GEAR_2: speed -= acceleration
			speed = max(speed, SPEED_GEAR_2)
		
	# Add gravity
	if (gravity < MAX_GRAVITY): gravity += GRAVITY_INC
			
	# Set velocity
	velocity = Vector2(direction * speed * delta, gravity)
	
func _move_and_slide(delta):
	"""Handle movement and and sliding while"""
	var remainder = move(velocity)
	
	# Handle sliding
	if is_colliding():
		if (get_collision_normal().x != 0):
			velocity.x = 0
			
		_jumping(delta)
		
		var n = get_collision_normal()
		remainder = n.slide(remainder)
		velocity = n.slide(velocity)
		move(remainder)
		
func _jumping(delta):
	"""Allows player to jump on input"""
	var n = get_collision_normal()
	
	# Jump if touching floor
	if (n.y == -1):
		if (Input.is_action_pressed("ui_jump")): 
			gravity = -JUMPPOWER * delta
			on_ground = false
		else: 
			gravity = 0
			on_ground = true
	# Stop if hitting ceiling
	elif (n.y == 1): 
		gravity = 0
	
func in_first_gear():
	"""Return true if in first gear"""
	return gear == 1
	
func in_second_gear():
	"""Return true if in second gear"""
	return gear == 2
	
func switch_gears():
	"""Switch the current gear of the player"""
	if in_first_gear():
		gear = 2
	else:
		gear = 1