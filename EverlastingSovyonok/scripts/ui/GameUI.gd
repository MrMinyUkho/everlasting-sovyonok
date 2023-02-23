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
	"А": 26, "а": 58,
	"Б": 27, "б": 59,
	"В": 28, "в": 60,
	"Г": 29, "г": 61,
	"Д": 30, "д": 62,
	"Е": 31, "е": 63,
	"Ж": 32, "ж": 64,
	"З": 33, "з": 65,
	"И": 34, "и": 66,
	"Й": 35, "й": 67,
	"К": 36, "к": 68,
	"Л": 37, "л": 69,
	"М": 38, "м": 70,
	"Н": 39, "н": 71,
	"О": 40, "о": 72,
	"П": 41, "п": 73,
	"Р": 42, "р": 74,
	"С": 43, "с": 75,
	"Т": 44, "т": 76,
	"У": 45, "у": 77,
	"Ф": 46, "ф": 78,
	"Х": 47, "х": 79,
	"Ц": 48, "ц": 80,
	"Ч": 49, "ч": 81,
	"Ш": 50, "ш": 82,
	"Щ": 51, "щ": 83,
	"Ъ": 52, "ъ": 84,
	"Ы": 53, "ы": 85,
	"Ь": 54, "ь": 86,
	"Э": 55, "э": 87,
	"Ю": 56, "ю": 88,
	"Я": 57, "я": 89
}

onready var DG_Border = get_node("./FilmLines/Dialog/DialogBorder")
onready var DG_Text   = get_node("./FilmLines/Dialog/Text")

var cutscene = false
var showDialog = true
var who_speak = "sl"
var text_line = ""
var start_say = 0
var cps = 30
var time_d_start = 0

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
		if time_d_start == 0:
			time_d_start = OS.get_ticks_msec()
		$FilmLines/Dialog/DialogBorder.modulate = dlg_colors[who_speak]
		var cell_columns = 10
		var cell_rows    = 2
		var icondrawat = DrawBorder(5,4,5,5)
		var textdrawat = DrawBorder(cell_columns+7, cell_rows+1, cell_columns+2, cell_rows+2)
		if textdrawat != null:
			$FilmLines/Dialog/Text.position = textdrawat
		var x = 0
		for i in range(len(text_line)):
			if float(i) / cps * 1000 > OS.get_ticks_msec() - time_d_start:
				break
			var tileid = charmap[text_line[i]]
			DG_Text.set_cellv(Vector2(x%((cell_columns-1)*3),x/((cell_columns-1)*3)), tileid)
			x += 1
			
		
