extends Node2D

var MapGeneration = load("res://tiles/MapGeneration.gd").new()

func _ready():
	add_child(MapGeneration)
