extends Node

func save_game():
	var Root = get_tree().get_root() 
	var GlobalVars = Root.get_child(Root.get_child_count() - 1).GlobalVars

	var data = {
		"highscore": GlobalVars.Score.highscore,
	}
	
	var file = File.new()
	if file.open("user://saved_game.sav", File.WRITE) != 0:
	    print("Error opening file")
	    return
	
	file.store_line(data.to_json())
	file.close()
	
func load_game():
	var Root = get_tree().get_root() 
	var GlobalVars = Root.get_child(Root.get_child_count() - 1).GlobalVars
	# Find saved file
	var file = File.new()
	if !file.file_exists("user://saved_game.sav"):
	    print("No file saved!")
	    return
	
	# Open file
	if file.open("user://saved_game.sav", File.READ) != 0:
	    print("Error opening file")
	    return
	
	# Get the data
	var data = {}
	data.parse_json(file.get_line())
	
	if (data != null):
		for i in get_tree().get_nodes_in_group("save_nodes"):
			i.load_game(data)