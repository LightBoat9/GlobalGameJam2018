extends Node

func _ready():
	OS.set_borderless_window(true)
	set_process_input(true)
	
func _input(event):
	if event.is_action_pressed("ui_fullscreen"):
		OS.set_window_fullscreen(not OS.is_window_fullscreen())
