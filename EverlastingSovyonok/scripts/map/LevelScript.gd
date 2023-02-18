extends Node2D

onready var player = get_node("./Player")
onready var camera = get_node("./Camera2D")

var player_pos = Vector2()
var camera_pos = Vector2()

var res = OS.get_window_size()

func _ready():
	print(res)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	res = OS.get_window_size()
	
	player_pos = player.position
	camera_pos = camera.position
	
	var min_x = player_pos.x - res[0] / 6 - res[0] / 2
	var max_x = player_pos.x + res[0] / 6 - res[0] / 2
	var min_y = player_pos.y - res[1] / 6 - res[1] / 2
	var max_y = player_pos.y + res[1] / 6 - res[1] / 2

	camera.position.x = clamp(camera_pos.x, min_x, max_x)
	camera.position.y = clamp(camera_pos.y, min_y, max_y)
	
