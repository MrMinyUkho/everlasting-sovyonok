class ScenarioParser:
	var scn : Dictionary
	var vars : Dictionary
	var characters : Dictionary
	
	func _init(path_to_scenario : String):
		var file = FileAccess.open(path_to_scenario, FileAccess.READ)
		var text = file.get_as_text()
		file.close()
		var test_json_conv = JSON.new()
		test_json_conv.parse(text)
		self.scn = test_json_conv.get_data()
		vars = self.scn["variables"]
	
	# Создание и настройка игрока
	func get_hero():
		var hero_settings = self.scn["characters"]["main_hero"]
		var hero = {}
		hero["object"] = load("res://characters/Player.tscn").instantiate()
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
			NPCs[i]["object"] = load("res://characters/NPC.tscn").instantiate()
			NPCs[i]["object"].position = Vector2(npc["InitPos"][0], npc["InitPos"][1])
			NPCs[i]["object"].whoami = i
			var c = npc["Color"]
			NPCs[i]["Color"] = Color(c[0], c[1], c[2])
			NPCs[i]["Name"] = npc["Name"]
			NPCs[i]["ShortForm"] = npc["ShortForm"]
		return NPCs
		
	func getNPCAction(npc : String, time : int):
		var actions = scn["TimeTable"][npc]
		var action  = {}
		if str(time) in actions:
			action = {}
			var rawact = actions[str(time)]
			if "pursuit" in rawact["action"]:
				action["type"] = "pursuit"
				action["target"]  = rawact["action"]["pursuit"]["target"]
				action["startat"] = rawact["action"]["pursuit"]["startat"]
				action["stopon"]  = rawact["action"]["pursuit"]["stopon"]
				if "dialog" in rawact:
					action["dialog"] = rawact["dialog"]
			elif "moveto" in rawact["action"]:
				print("moveto")
				action["type"] = "moveto"
				action["topos"] = Vector2(rawact["action"]["moveto"][0], rawact["action"]["moveto"][1])
		return action

	func note_choice(choice):
		if "+" in choice:
			choice = choice.split("+")
			self.vars[choice[0]] += int(choice[1])
		elif "-" in choice:
			choice = choice.split("-")
			self.vars[choice[0]] -= int(choice[1])
		else:
			traceback()

	func traceback():
		print("Выявлена ошибка в файле сценария:")
