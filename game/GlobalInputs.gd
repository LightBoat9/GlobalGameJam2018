extends Node

func _ready():
	set_pause_mode(PAUSE_MODE_PROCESS)
	set_process_input(true)
	
func _input(event):
	if event.is_action_pressed("ui_fullscreen"):
		OS.set_window_fullscreen(not OS.is_window_fullscreen())
		OS.set_borderless_window(OS.is_window_fullscreen())
	if event.is_action_pressed("ui_pause"):
		get_tree().set_pause(not get_tree().is_paused())