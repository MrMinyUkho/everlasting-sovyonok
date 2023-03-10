class ScenarioParser:
	var scn : Dictionary
	var vars : Dictionary
	var characters : Dictionary
	
	func _init(var path_to_scenario : String):
		var file = File.new()
		file.open(path_to_scenario, File.READ)
		var text = file.get_as_text()
		file.close()
		self.scn = parse_json(text)
		vars = self.scn["variables"]
	
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
		
	func getNPCAction(var npc : String, var time : int):
		var actions = scn["TimeTable"][npc]
		var action = null
		if str(time) in actions:
			action = {}
			var rawact = actions[str(time)]
			action["type"] = rawact["type"]
			if action["type"] == "pursuit":
				action["target"] = rawact["target"]
				action["startat"] = rawact["startat"]
				action["stopon"] = rawact["stopon"]
				if "dialog" in rawact:
					action["dialog"] = rawact["dialog"]
		return action

	func note_choice(var choice):
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
