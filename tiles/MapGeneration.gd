extends Node

var maps = [
	load("res://tiles/Maps/0.tscn"),
	load("res://tiles/Maps/1.tscn"),
	load("res://tiles/Maps/2.tscn"),
	load("res://tiles/Maps/3.tscn"),
	load("res://tiles/Maps/4.tscn"),
	load("res://tiles/Maps/5.tscn"),
	load("res://tiles/Maps/6.tscn"),
	load("res://tiles/Maps/7.tscn"),
	load("res://tiles/Maps/8.tscn")
]

var MAP_HEIGHT = 384
var map_count = 0

onready var Root = get_tree().get_root() 
onready var GlobalVars = Root.get_child(Root.get_child_count() - 1).GlobalVars

func _ready():
	_spawn_level(rand_map())
	_spawn_level(rand_map())
	set_process(true)
	
func _process(delta):
	if abs(int(GlobalVars.Player.get_pos().y) / MAP_HEIGHT) == map_count - 2:
		_spawn_level(rand_map())
	
func _spawn_level(level):
	var map = level.instance()
	map.set_pos(Vector2(0, 0 - (MAP_HEIGHT * map_count)))
	GlobalVars.Game.add_child(map)
	map_count += 1
	
func rand_map():
	"""Returns a random map from the maps array"""
	randomize()
	return maps[rand_range(0, maps.size())]