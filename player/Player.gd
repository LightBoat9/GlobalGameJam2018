extends KinematicBody2D

var gear = 1

var SPEED_GEAR_1 = 100
var SPEED_GEAR_2 = 300
var speed = SPEED_GEAR_1
var acceleration = 5

var gravity = 0
var GRAVITY_INC = 20
var MAX_GRAVITY = 500

var JUMPPOWER = 500
var BOOST_POWER = 500
var in_boost_mode = false

var direction = 1

var on_ground = false

var boost_velocity = Vector2()
var velocity = Vector2()

onready var anim = get_node("Anims")

func _ready():
	get_node("BoostTimer").connect("timeout", self, "boost_mode_end")
	set_process_input(true)
	set_fixed_process(true)
	
func _input(event):
	# Switch gears on user input
	if event.is_action_pressed("ui_interact"):
		if in_second_gear() and on_ground or in_first_gear():
			if in_first_gear():
				start_boost_mode()
				speed = BOOST_POWER
			switch_gears()
	
func _fixed_process(delta):
	_velocity(delta)
	_move_and_slide()
	_animate()

func _animate():
	var horz = velocity.x
	
	if velocity.x < 0:
		anim.set_flip_h(true)
	elif velocity.x > 0:
		anim.set_flip_h(false)
	
	if on_ground:
		if velocity.x == 0:
			anim.set_animation("stand")
		elif in_first_gear():
			anim.set_animation("walk")
		else:
			anim.set_animation("run")
	else:
		anim.set_animation("jump")
		var vert = round(velocity.y)
		
		if vert < 0:
			anim.set_frame(0)
		elif vert > 0:
			anim.set_frame(2)
		else:
			anim.set_frame(1)

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
	
	# Speed based on gear and input
	if h_in == 0: # While not moving
		if speed > 0: speed -= acceleration
	else: # While moving
		if in_first_gear():
			if speed < SPEED_GEAR_1: speed += acceleration
			elif speed > SPEED_GEAR_1: speed -= acceleration
			speed = max(speed, SPEED_GEAR_1)
		elif in_second_gear():
			if on_ground:
				if speed < SPEED_GEAR_2: speed += acceleration
				elif speed > SPEED_GEAR_2: speed -= acceleration
				speed = max(speed, SPEED_GEAR_2)
		
	# Add gravity
	if not in_boost_mode:
		if (gravity < MAX_GRAVITY): 
			gravity += GRAVITY_INC
			
	# Set velocity
	velocity = Vector2(direction * speed, gravity) * delta
	
func _move_and_slide():
	"""Handle movement and and sliding while"""
	var remainder = move(velocity)
	
	# Handle sliding
	if is_colliding():
		if (get_collision_normal().x != 0):
			velocity.x = 0
			speed = 0
			direction = -direction
			
		_jumping()
		
		var n = get_collision_normal()
		remainder = n.slide(remainder)
		velocity = n.slide(velocity)
		move(remainder)
		
	if gravity != 0:
		on_ground
		
func _jumping():
	"""Allows player to jump on input"""
	var n = get_collision_normal()
	
	# Jump if touching floor
	if (n.y == -1):
		if (Input.is_action_pressed("ui_jump")): 
			gravity = -JUMPPOWER
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
		
func start_boost_mode():
	get_node("BoostTimer").start()
	in_boost_mode = true
		
func boost_mode_end():
	in_boost_mode = false