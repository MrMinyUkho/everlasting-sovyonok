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
	
	if Input.is_action_pressed("ui_accept"):
		slavya.walk = true
		slavya.target = player
	
	children.sort_custom(SortByY, "sort_ascending")
	
	for i in range(len(children)):
		if children[i] != level:
			children[i].z_index = i - 4094
	
	if slavya.walk == false and slavya.target == player:
		player.InDialog = true
		$Camera2D/UI_slot/UI.cutscene = true
		player.DialogTarget = slavya
	
	res = OS.get_window_size()
	
	player_pos = player.position
	camera_pos = camera.position
	
	if player.InDialog == true:
		var target_pos = player.DialogTarget.position
		var target_cam_pos = (target_pos - res / 2 + (player_pos - target_pos) / 2)
		# Камера между игроком и NPC в катсцене
		# Плюс интерполяция
		if (target_cam_pos-camera_pos).length() > 5:
			camera.position *= 0.9
			camera.position += 0.1 * target_cam_pos
		else:
			camera.position = target_cam_pos
		#camera.position.x = float(int(camera.position.x*10)) / 10
		#camera.position.y = float(int(camera.position.y*10)) / 10
	else:
		# Некоторая свобода камере
		
		var min_x = player_pos.x - res[0] / 6 - res[0] / 2
		var min_y = player_pos.y - res[1] / 6 - res[1] / 2
		var max_x = player_pos.x + res[0] / 6 - res[0] / 2
		var max_y = player_pos.y + res[1] / 6 - res[1] / 2
	
		camera.position.x = clamp(camera_pos.x, min_x, max_x)
		camera.position.y = clamp(camera_pos.y, min_y, max_y)
	
