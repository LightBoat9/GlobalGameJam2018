extends StaticBody2D

onready var Root = get_tree().get_root() 
onready var GlobalVars = Root.get_child(Root.get_child_count() - 1).GlobalVars

var in_second_gear = false

func _ready():
	set_process(true)
	GlobalVars.Player.connect("gear_toggle", self, "_gear_toggle")
	get_node("Area2D").connect("body_enter", self, "player_enter")
	
func _gear_toggle():
	print("TEST")
	get_node("CollisionShape2D").set_trigger(GlobalVars.Player.in_first_gear())

func player_enter(body):
	if body == GlobalVars.Player:
		queue_free()

func destroy():
	queue_free()
