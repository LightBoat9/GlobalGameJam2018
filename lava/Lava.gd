extends KinematicBody2D

var SPEED = 60
var CLAMP_DIST = 600

var velocity = Vector2(0, -SPEED)

onready var Root = get_tree().get_root() 
onready var GlobalVars = Root.get_child(Root.get_child_count() - 1).GlobalVars

func _ready():
	get_node("Area2D").connect("body_enter", self, "player_enter")
	set_process(true)
	
func _process(delta):
	var player_dist = abs(GlobalVars.Player.get_pos().y - get_pos().y)
	set_pos(Vector2(get_pos().x, min(get_pos().y, GlobalVars.Player.get_pos().y + CLAMP_DIST)))
	
	move(velocity * delta)
	
func player_enter(body):
	if body == GlobalVars.Player:
		get_tree().reload_current_scene()