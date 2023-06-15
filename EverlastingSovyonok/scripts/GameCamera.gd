extends Camera2D

var target

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player_pos = target.position
	var res = get_window().get_size()
	
	if target.InDialog == true:
		# Позиция камеры между игроком и НПС в диалоге
		var target_pos = target.DialogTarget.position
		var target_cam_pos = (player_pos + target_pos - Vector2(res)) / 2
		position = target_cam_pos
	else:
		# Некоторая свобода камере в процессе перемещения
		var cam_x = player_pos.x - res[0] / 2
		var cam_y = player_pos.y - res[1] / 2
		
		position.x = clamp(position.x, cam_x - res[0]/30, cam_x + res[0]/30)
		position.y = clamp(position.y, cam_y - res[1]/30, cam_y + res[1]/30)
