extends Node

var maps = [
	load("res://tiles/Maps/0.tscn"),
]

var MAP_HEIGHT = 384
var map_count = 0

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
	return maps[rand_range(0, maps.size() - 1)]