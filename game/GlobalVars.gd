extends Node

onready var Root = get_tree().get_root()
onready var Game = get_parent()
onready var Player = Game.get_node("Player")