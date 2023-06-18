extends Node

var TimeProc    = true

var GameStart   = false

var CurrentDay  = 0
var GlobalTime  = 545
var GlobalColor = Vector3(1,1,1)

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

func NPC_signal(npc, sig):
	pass

func _ready():
	parser = ScenarioParser.ScenarioParser.new("res://scenario/day1.json")
	
	scene = get_node("/root/DevRoom")
	
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
		
	
	
