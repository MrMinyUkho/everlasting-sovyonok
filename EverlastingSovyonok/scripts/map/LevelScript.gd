extends Node2D

onready var camera = get_node("./Camera2D")
onready var level  = get_node("./bus_stop_tilemap")

var player_pos = Vector2()
var camera_pos = Vector2()

var player : Node
var NPCs : Dictionary

var inGameTime = 540 # 9 часов (секунда = минута)

var res = OS.get_window_size()


class SortByY:
	static func sort_ascending(a, b):
		if a.position.y < b.position.y:
			return true
		return false

class ScenarioParser:
	var scn : Dictionary
	var vars : Dictionary
	var key_words : Array
	var characters : Dictionary
	
	func _init(var path_to_scenario : String):
		var file = File.new()
		file.open(path_to_scenario, File.READ)
		var text = file.get_as_text()
		file.close()
		self.scn = parse_json(text)
		vars = {}
		key_words = [
			"say",
			"choice",
			"goto"
		]
	
	# Создание и настройка игрока
	func get_hero():
		var hero_settings = self.scn["characters"]["main_hero"]
		var hero = {}
		hero["object"] = load("res://characters/Player.tscn").instance()
		hero["object"].position = Vector2(hero_settings["InitPos"][0], hero_settings["InitPos"][1])
		var c = hero_settings["Color"]
		hero["Color"] = Color(c[0], c[1], c[2])
		hero["Name"] = hero_settings["Name"]
		hero["ShortForm"] = hero_settings["ShortForm"]
		return hero

	# Создание и настройка НПСишек
	func get_NPCs():
		var NPCs = {}
		for i in self.scn["characters"]:
			if i == "main_hero":
				continue
			var npc = self.scn["characters"][i]
			NPCs[i] = {}
			NPCs[i]["object"] = load("res://characters/NPC.tscn").instance()
			NPCs[i]["object"].position = Vector2(npc["InitPos"][0], npc["InitPos"][1])
			NPCs[i]["object"].whoami = i
			var c = npc["Color"]
			NPCs[i]["Color"] = Color(c[0], c[1], c[2])
			NPCs[i]["Name"] = npc["Name"]
			NPCs[i]["ShortForm"] = npc["ShortForm"]
		return NPCs
	
	func traceback():
		print("Выявлена ошибка в файле сценария:")


var parser : ScenarioParser

func _ready():
	parser = ScenarioParser.new("res://scenario/day1.json")

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
		inGameTime += delta # это надо переписать под модуль Time
	
	var children = self.get_children()
	
	#if Input.is_action_pressed("ui_accept"):
	#	slavya.walk = true
	#	slavya.target = player
	
	children.sort_custom(SortByY, "sort_ascending")
	
	for i in range(len(children)):
		if children[i] != level:
			children[i].z_index = i - 4094
	
	#if slavya.walk == false and slavya.target == player:
	#	player.InDialog = true
	#	$Camera2D/UI_slot/UI.cutscene = true
	#	$Camera2D/UI_slot/UI.text_line = "Привет, ты наверное новенький?"
	#	player.DialogTarget = slavya
	
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
