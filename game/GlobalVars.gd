extends Node

onready var Root = get_tree().get_root()
onready var Game = get_parent()
onready var Player = Game.get_node("Player")
onready var Lava = Game.get_node("Lava")
onready var Score = Game.get_node("CanvasLayer/Score")
onready var Best = Game.get_node("CanvasLayer/Best")