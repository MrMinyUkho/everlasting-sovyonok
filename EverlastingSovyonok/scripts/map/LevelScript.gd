extends Node2D

onready var camera = get_node("./Camera2D")
onready var level  = get_node("./bus_stop_tilemap")

var player_pos = Vector2()
var camera_pos = Vector2()

var player : Node
var NPCs : Dictionary

var inGameTime = 540 # 9 часов (секунда = минута)
var deltaTimeInt = 0 # Надо для проверки раз в секунду, а не раз в кадр

var res = OS.get_window_size()


class SortByY:
	static func sort_ascending(a, b):
		if a.position.y < b.position.y:
			return true
		return false

const ScenarioParser = preload("res://scripts/map/ScenarioParser.gd")
var parser


func _ready():
	parser = ScenarioParser.ScenarioParser.new("res://scenario/day1.json")

	var hero = parser.get_hero()
	player = hero["object"]
	add_child(player)

	NPCs = parser.get_NPCs()
	for i in NPCs:
		add_child(NPCs[i]["object"])
		$Camera2D/UI_slot/UI.dialog_color_name[NPCs[i]["ShortForm"]] = [NPCs[i]["Color"], i]
	
	$Camera2D/UI_slot/UI.dialog_color_name[hero["ShortForm"]] = [hero["Color"], hero["Name"]]
	# Тут мы раскидали всё по всем местам для дальнейшего использования
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if player.InDialog == false:
		inGameTime += delta # это надо оставить потому что работает пиздато
	
	# Это для сортировки спрайтов по Y, для добавления глубины уровня
	var children = self.get_children()
	
	children.sort_custom(SortByY, "sort_ascending")
	
	for i in range(len(children)):
		if children[i] != level:
			children[i].z_index = i - 4094
	
	# Проверка внутриигровых событий
	
	if int(inGameTime) > deltaTimeInt:
		deltaTimeInt = int(inGameTime)
		# Проверка чем занимаются NPC 
		for i in NPCs:
			var action = parser.getNPCAction(i, deltaTimeInt)
			if action == null:
				continue
			if action["type"] == "pursuit":
				NPCs[i]["object"].state = "pursuit"
				if action["target"] == "main_hero":
					NPCs[i]["object"].target = player
				NPCs[i]["object"].startat = action["startat"]
				NPCs[i]["object"].stopon = action["stopon"]
	

func _physics_process(delta):
	res = OS.get_window_size()
	
	player_pos = player.position
	camera_pos = camera.position
	
	if player.InDialog == true:
		var target_pos = player.DialogTarget.position
		# Камера между игроком и NPC в катсцене
		var target_cam_pos = (player_pos + target_pos - res) / 2
		# Плюс интерполяция
		if (target_cam_pos-camera_pos).length() > 1:
			camera.position *= 0.9
			camera.position += 0.1 * target_cam_pos
		else:
			camera.position = target_cam_pos
	else:
		# Некоторая свобода камере
		var cam_x = player_pos.x - res[0] / 2
		var cam_y = player_pos.y - res[1] / 2

		camera.position.x = clamp(camera_pos.x, cam_x - res[0]/6, cam_x + res[0]/6)
		camera.position.y = clamp(camera_pos.y, cam_y - res[1]/6, cam_y + res[1]/6)
