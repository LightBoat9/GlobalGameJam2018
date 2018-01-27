extends KinematicBody2D

var SPEED = 60
var SPEED_INC = 10 # Amount to increase speed when player is far
var DIST_INC = 200 # Distance player must be to increase speed

var velocity = Vector2(0, -SPEED)

func _ready():
	set_process(true)
	
func _process(delta):
	var player_dist = abs(GlobalVars.Player.get_pos().y - get_pos().y)
	velocity = Vector2(0, -SPEED + (SPEED_INC * (SPEED * (player_dist / DIST_INC))))
	
	move(velocity * delta)
