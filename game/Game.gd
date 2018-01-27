extends Node2D

var MapGeneration = load("res://tiles/MapGeneration.gd").new()
var GlobalVars = preload("res://game/GlobalVars.gd").new()

func _enter_tree():
	add_child(GlobalVars)
	
func _ready():
	add_child(MapGeneration)
