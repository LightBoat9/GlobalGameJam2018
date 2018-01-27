extends Container

onready var small = get_node("gear_small")
onready var small_base = small.get_pos()
onready var small_off = small_base-Vector2(0,16)
onready var small_rotBase = small.get_rot()
onready var small_rot = small_rotBase
var small_mult = 0.5

onready var med = get_node("gear_med")
onready var med_rotBase = med.get_rot()
onready var med_rot = med_rotBase

onready var big = get_node("gear_big")
onready var big_base = big.get_pos()
onready var big_off = big_base+Vector2(0,16)
onready var big_rotBase = big.get_rot()
onready var big_rot = big_rotBase
var big_mult = 2

var rotRate = 5

var smallOrBig = true
var transition = 0

var speed = 0
var accel = 0.5
var active
var inactive

func _ready():
	set_process(true)
	#set_process_input(true)
	if smallOrBig:
		big.set_pos(big_off)
		active = small
	else:
		small.set_pos(small_off)
		inactive = big

func _toggle():
	smallOrBig = !smallOrBig
	med.set_rot(med_rotBase)
	transition = 1
	if smallOrBig:
		big.set_rot(big_rotBase)
		active = small
	else:
		small.set_rot(small_rotBase)
		inactive = big

func _input(event):
	if event.is_action_pressed("ui_accept"):
		_toggle()

func _process(delta):
	if transition == 1:
		var done
		if smallOrBig:
			done = _transfer(big,big_off)
		else:
			done = _transfer(small,small_off)
		if done:
			transition = 2
	elif transition == 2:
		var done
		if smallOrBig:
			done = _transfer(small,small_base)
		else:
			done = _transfer(big,big_base)
		if done:
			transition = 0
	else:
		_rotate()

func _transfer(gear, target):
	var dist = target.y - gear.get_pos().y
	var dir = sign(dist)
	speed += accel*dir
	
	if abs(dist) <= abs(speed):
		gear.set_pos(target)
		speed = 0
		return true
	else:
		var vect = gear.get_pos() + Vector2(0,speed)
		gear.set_pos(vect)
		return false

func _rotate():
	if smallOrBig:
		small_rot += rotRate
		med_rot -= rotRate * small_mult
		small.set_rot(small_rot)
		med.set_rot(med_rot)
	else:
		big_rot += rotRate
		med_rot -= rotRate * big_mult
		big.set_rot(big_rot)
		med.set_rot(med_rot)