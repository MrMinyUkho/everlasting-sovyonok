extends Node2D

onready var player = get_node("./Player")
onready var camera = get_node("./Camera2D")
onready var slavya = get_node("./Slavya")
onready var level  = get_node("./bus_stop_tilemap")

var player_pos = Vector2()
var camera_pos = Vector2()

var res = OS.get_window_size()

class SortByY:
	static func sort_ascending(a, b):
		if a.position.y < b.position.y:
			return true
		return false

func _ready():
	
	slavya.stopon = 100
	print(res)
	player.position = Vector2(-500, -250)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var children = self.get_children()
	
	children.sort_custom(SortByY, "sort_ascending")
	
	for i in range(len(children)):
		if children[i] != level:
			children[i].z_index = i - 4094
	
	slavya.target = player_pos
	
	res = OS.get_window_size()
	
	player_pos = player.position
	camera_pos = camera.position
	
	var min_x = player_pos.x - res[0] / 6 - res[0] / 2
	var max_x = player_pos.x + res[0] / 6 - res[0] / 2
	var min_y = player_pos.y - res[1] / 6 - res[1] / 2
	var max_y = player_pos.y + res[1] / 6 - res[1] / 2

	camera.position.x = clamp(camera_pos.x, min_x, max_x)
	camera.position.y = clamp(camera_pos.y, min_y, max_y)
	
