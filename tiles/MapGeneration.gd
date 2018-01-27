extends Node

var maps = [
	load("res://tiles/Maps/0.tscn"),
]

func _ready():
	var map = maps[0].instance()
	GlobalVars.Game.add_child(map)
	set_process(true)
	
func _process(delta):
	#print(GlobalVars.Player.get_pos())
	pass
	
func rand_map():
	pass