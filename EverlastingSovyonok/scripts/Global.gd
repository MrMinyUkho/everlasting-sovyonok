extends Node

var TimeProc    = true

var GameStart   = true

var CurrentDay    = 0
var GlobalTime    = 560
var GlobalTimeInt = 560
var GlobalColor   = Vector3(1,1,1)

var SunColor = Vector3(0.8, 0.9,   1)
var DayColor = Vector3(  1,   1,   1)
var EvgColor = Vector3(  1, 0.6, 0.7)
var NgtColor = Vector3(0.4, 0.6, 0.7)

const ScenarioParser = preload("res://scripts/map/ScenarioParser.gd")
var parser

var NPCs
var Hero
var UI
var Camera
var scene

var ActsArr : Dictionary

func NPC_signal(npc, sig):
	if(sig[0] == "start_dialog" and npc != null):
		print("Transmit signal")
		UI.vars = parser.vars
		UI.dialog = ActsArr[npc.whoami]
		UI.cutscene = true
		UI.gen_label()
		Hero.DialogTarget = NPCs[npc.whoami]["object"]
		Hero.InDialog = true
		TimeProc = false
	elif("choice:" in sig[0]):
		parser.note_choice(sig.replace("choice:", ""))
		UI.vars = parser.vars
	elif(sig[0] == "edvar"):
		parser.note_choice(sig[1]+"+"+str(sig[2]))
		UI.vars = parser.vars
	elif(sig[0] == "end_dialog"):
		UI.cutscene = false
		Hero.DialogTarget = null
		Hero.InDialog = false
		TimeProc = true
	
	

func _ready():
	parser = ScenarioParser.ScenarioParser.new("res://scenario/day1.json")
	
	scene = get_node("/root/DevRoom")
	print(scene)
	UI = get_node("/root/DevRoom/Camera2D/UI_slot/UI")
	Camera = get_node("/root/DevRoom/Camera2D")
	
	NPCs = parser.get_NPCs()
	for i in NPCs:
		
		scene.add_child(NPCs[i]["object"])
		UI.dialog_color_name[NPCs[i]["ShortForm"]] = [NPCs[i]["Color"], i]
	
	Hero = parser.get_hero()
	Camera.target = Hero["object"]
	scene.add_child(Hero["object"])
	UI.dialog_color_name[Hero["ShortForm"]] = [Hero["Color"], Hero["Name"]]
	Hero = Hero["object"]

func _process(delta):
	
	if TimeProc and GameStart:
		GlobalTime += delta
		
		# Проверка внутриигровых событий
		if int(GlobalTime) > GlobalTimeInt:
			GlobalTimeInt = int(GlobalTime)
			# Проверка чем должны заниматься NPC 
			for i in NPCs:
				var action = parser.getNPCAction(i, GlobalTimeInt)
				if action.is_empty():
					continue
				NPCs[i]["action"] = action
				if action["type"] == "pursuit":
					NPCs[i]["object"].state = "pursuit"
					if action["target"] == "main_hero":
						NPCs[i]["object"].target = Hero
					NPCs[i]["object"].startat = action["startat"]
					NPCs[i]["object"].stopon = action["stopon"]
					if "dialog" in action:
						NPCs[i]["object"].startDialog = true
						ActsArr[i] = action["dialog"]
				elif action["type"] == "moveto":
					print("moveto")
					NPCs[i]["object"].state = "move"
					NPCs[i]["object"].target = action["topos"]
	
