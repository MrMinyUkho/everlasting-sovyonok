extends Control


# Declare member variables here. Examples:

const dlg_colors = {
	"sl": Color(1.0, 0.8, 0), 
	"dv": Color(), 
	"un": Color(), 
	"mz": Color(), 
	"mt": Color(), 
	"el": Color(), 
	"sh": Color(), 
	"mi": Color(), 
	"uw": Color(), 
}

const charmap = {
	"!": 0,
	".": 1,
	"?": 2,
	",": 3,
	":": 4,
	";": 5,
	"0": 6,
	"1": 7,
	"2": 8,
	"3": 9,
	"4": 10,
	"5": 11,
	"6": 12,
	"7": 13,
	"8": 14,
	"9": 15,
	"<": 16,
	">": 17,
	" ": 25,
	"А": 27,
	"Б": 28,
	"В": 29,
	"Г": 30,
	"Д": 31,
	"Е": 32,
	"Ж": 33,
	"З": 34,
	"И": 35,
	"Й": 36,
	"К": 37,
	"Л": 38,
	"М": 39,
	"Н": 40,
	"О": 41,
	"П": 42,
	"Р": 43,
	"С": 44,
	"Т": 45,
	"У": 46,
	"Ф": 47,
	"Х": 48,
	"Ц": 49,
	"Ч": 50,
	"Ш": 51,
	"Щ": 52,
	"Ъ": 53,
	"Ы": 54,
	"Ь": 55,
	"Э": 56,
	"Ю": 57,
	"Я": 58,
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
	var c = null
	var scale = $FilmLines/Dialog/DialogBorder.scale*16
	for i in range(w):
		for j in range(h):
			var tid = 4
			if i + j == 0:
				tid = 0
			elif j == h - 1 and i == 0:
				tid = 6
			elif i == w - 1 and j == 0:
				tid = 2
			elif i == h - 1 and j == w - 1:
				tid = 8
			elif i == w - 1:
				tid = 5
			elif j == h - 1:
				tid = 7
			elif j == 0:
				tid = 1
			elif i == 0:
				tid = 3
			else:
				if c == null:
					c = Vector2((-x+i)*scale.x, (-y+j)*scale.y)
				tid = 4
			DG_Border.set_cell(-x+i, -y+j, tid)
	return c
# warning-ignore:unused_argument
func _process(delta):
	
	$FilmLines.visible = cutscene
	$GameUI.visible = !cutscene
	
	$FilmLines/Dialog.visible = showDialog

	if showDialog and text_line != "":
		$FilmLines/Dialog/DialogBorder.modulate = dlg_colors[who_speak]
		var cell_columns = 10
		var cell_rows    = 2
		var icondrawat = DrawBorder(5,4,5,5)
		var textdrawat = DrawBorder(cell_columns+7, cell_rows+1, cell_columns+2, cell_rows+2)
		if textdrawat != null:
			$FilmLines/Dialog/Text.position = textdrawat
		var x = 0
		for i in text_line:
			print(i)
			var tileid = 25
			if i.to_lower() == i:
				tileid = charmap[i.to_upper()] + 31
			else:
				tileid = charmap[i] - 1
			DG_Text.set_cellv(Vector2(x%((cell_columns-1)*3),x/((cell_columns-1)*3)), tileid)
			x += 1
	
