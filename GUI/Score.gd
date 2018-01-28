extends Label

onready var Root = get_tree().get_root() 
onready var GlobalVars = Root.get_child(Root.get_child_count() - 1).GlobalVars

var score = 0
var start_y = 0

func _ready():
	start_y = GlobalVars.Player.get_pos().y
	set_process(true)

func _process(delta):
	var player_y = int(start_y - GlobalVars.Player.get_pos().y)
	score = max(player_y, score)
	set_text("Score: " + str(score))
