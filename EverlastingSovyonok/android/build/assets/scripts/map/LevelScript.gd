extends Node2D

@onready var camera = get_node("./Camera2D")
@onready var level  = get_node("./bus_stop_tilemap")
@onready var Glob   = get_node("/root/Global")
@onready var UI     = get_node("./Camera2D/UI_slot/UI")

var player_pos = Vector2()
var camera_pos = Vector2()

var player : Node
var NPCs : Dictionary
var NPCs_signals : Dictionary


class SortByY:
	static func sort_ascending(a, b):
		if a.position.y < b.position.y:
			return true
		return false

var parser
	
func _process(delta):
		
	# Это для сортировки спрайтов по Y, для добавления глубины уровня
	var children = self.get_children()
	
	children.sort_custom(Callable(SortByY,"sort_ascending"))
	
	for i in range(len(children)):
		if children[i] != level:
			children[i].z_index = i - 4094
	
#	# Проверка внутриигровых событий
#	if int(inGameTime) > deltaTimeInt:
#		deltaTimeInt = int(inGameTime)
#		# Проверка чем должны заниматься NPC 
#		for i in NPCs:
#			var action = parser.getNPCAction(i, deltaTimeInt)
#			if action.is_empty():
#				continue
#			NPCs[i]["action"] = action
#			if action["type"] == "pursuit":
#				NPCs[i]["object"].state = "pursuit"
#				if action["target"] == "main_hero":
#					NPCs[i]["object"].target = player
#				NPCs[i]["object"].startat = action["startat"]
#				NPCs[i]["object"].stopon = action["stopon"]
#				if "dialog" in action:
#					NPCs[i]["object"].signal_to_parent = "dialog"
#
	
#	# Проверка чё NPC уже сделали
#	for i in NPCs_signals:
#		for j in range(len(NPCs_signals[i])):
#			if NPCs_signals[i].has("dialog"):
#				UI.vars = parser.vars
#				UI.dialog = NPCs[i]["action"]["dialog"]
#				UI.cutscene = true
#				UI.gen_label()
#				player.DialogTarget = NPCs[i]["object"]
#				player.InDialog = true
#				NPCs_signals[i].remove_at(j)
#				break
#			elif "choice:" in NPCs_signals[i][j]:
#				parser.note_choice(NPCs_signals[i][j].replace("choice:", ""))
#				UI.vars = parser.vars
#				NPCs_signals[i].remove_at(j)
#				break
#			elif i == "me" and "end_dialog" in NPCs_signals[i][j]:
#				UI.cutscene = false
#				player.DialogTarget = null
#				player.InDialog = false
#				NPCs_signals[i].remove_at(j)
#				break
