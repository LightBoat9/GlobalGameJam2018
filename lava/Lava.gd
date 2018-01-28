extends KinematicBody2D

var START_SPEED = 50
var MAX_SPEED = 70
var SPEED_INC = 2
var INC_DIST = 500
var CLAMP_DIST = 500

var velocity = Vector2(0, -START_SPEED)


onready var Root = get_tree().get_root() 
onready var GlobalVars = Root.get_child(Root.get_child_count() - 1).GlobalVars

func _ready():
	get_node("Area2D").connect("body_enter", self, "player_enter")
	set_process(true)
	
func _process(delta):
	var player_dist = abs(GlobalVars.Player.get_pos().y - get_pos().y)
	set_pos(Vector2(get_pos().x, min(get_pos().y, GlobalVars.Player.get_pos().y + CLAMP_DIST)))
	
	var speed = (START_SPEED + (int(GlobalVars.Score.score / INC_DIST) * SPEED_INC))
	speed = max(speed, MAX_SPEED)
	velocity.y = -speed
	
	move(velocity * delta)
	
func player_enter(body):
	if body == GlobalVars.Player:
		SaveLoad.save_game()
		get_tree().reload_current_scene()