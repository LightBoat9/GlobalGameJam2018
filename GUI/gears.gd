extends Container

signal gears_shifted

onready var small = get_node("gear_small")
onready var small_base = small.get_pos()
onready var small_off = small_base-Vector2(0,16)
onready var small_rotBase = small.get_rotd()
onready var small_rot = small_rotBase
var small_mult = 0.5

onready var med = get_node("gear_med")
onready var med_rotBase = med.get_rotd()
onready var med_rot = med_rotBase

onready var big = get_node("gear_big")
onready var big_base = big.get_pos()
onready var big_off = big_base+Vector2(0,16)
onready var big_rotBase = big.get_rotd()
onready var big_rot = big_rotBase
var big_mult = 2

var rotRate = 10

var smallOrBig = true
var transition = 0

var speed = 0
var accel = 0.5
var active
var inactive

onready var Root = get_tree().get_root() 
onready var GlobalVars = Root.get_child(Root.get_child_count() - 1).GlobalVars

func _ready():
	GlobalVars.Player.connect("gear_toggle", self, "_toggle")
	connect("gears_shifted",GlobalVars.Player,"switch_gears")
	set_process(true)
	if smallOrBig:
		big.set_pos(big_off)
		active = small
	else:
		small.set_pos(small_off)
		inactive = big

func _toggle():
	smallOrBig = !smallOrBig
	med.set_rotd(med_rotBase)
	med_rot = med_rotBase
	transition = 1
	if smallOrBig:
		big.set_rotd(big_rotBase)
		big_rot = big_rotBase
		active = small
	else:
		small.set_rotd(small_rotBase)
		inactive = big
		small_rot = small_rotBase

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
			emit_signal("gears_shifted")
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
		small.set_rotd(small_rot)
		med.set_rotd(med_rot)
	else:
		big_rot += rotRate
		med_rot -= rotRate * big_mult
		big.set_rotd(big_rot)
		med.set_rotd(med_rot)