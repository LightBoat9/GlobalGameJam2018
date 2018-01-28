extends TileMap
# Script that frees the map once the lava passes it

onready var Root = get_tree().get_root() 
onready var GlobalVars = Root.get_child(Root.get_child_count() - 1).GlobalVars

var FREE_OFFSET = 100

func _ready():
	set_process(true)
	
func _process(delta):
	if GlobalVars.Lava.get_pos().y < get_pos().y - FREE_OFFSET:
		print("TEST")
		queue_free()
