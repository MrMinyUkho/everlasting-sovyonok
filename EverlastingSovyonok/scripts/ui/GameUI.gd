extends Control


# Declare member variables here. Examples:

const dlg_colors = {
	"sl": Color(), 
	"dv": Color(), 
	"un": Color(), 
	"mz": Color(), 
	"mt": Color(), 
	"el": Color(), 
	"sh": Color(), 
	"mi": Color(), 
	"uw": Color(), 
}

onready var DG_Border = get_node("./FilmLines/Dialog/DialogBorder")
onready var DG_Text   = get_node("./FilmLines/Dialog/Text")

var cutscene = false
var showDialog = true
var who_speak = "sl"
var text_line = ""
var start_say = 0
var cpm = 300

var GapBorder = Vector2()
var TxtBorder = Vector2()

func DrawBorder(var x, var y, var w, var h):
	for i in range(y):
		for j in range(x):
			var tid = 4
			if i + j == 0:
				tid = 0
			elif j == 0:
				tid = 1
			elif i == 0:
				tid = 3
			elif i == 0 and j == x - 1:
				tid = 2
			elif i == y - 1 and j == 0:
				tid = 6
			elif i == y-1 and j == x - 1:
				tid = 8
			elif i == y-1:
				tid = 7
			elif j == x-1:
				tid = 5
			else:
				tid = 4
			DG_Border.set_cell(-x-w, -y-h, tid)

# warning-ignore:unused_argument
func _process(delta):
	
	$FilmLines.visible = cutscene
	$GameUI.visible = !cutscene
	
	$FilmLines/Dialog.visible = showDialog

	DrawBorder(5, 5, 3, 3)

	if showDialog and text_line != "":
		var cell_columns = ceil(text_line.length()/6)
		var cell_rows    = cell_columns % 7
		cell_columns    /= cell_rows
	
