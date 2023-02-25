extends Control


# Declare member variables here. Examples:

var dialog_color_name = {}

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

const em = {
	"normal": 0,
}

const dr = {
	"pioneer": 0,
}

onready var DG_Border = get_node("./FilmLines/Dialog/DialogBorder")
onready var DG_Text   = get_node("./FilmLines/Dialog/Text")


# Переменные для для диалогов
var cutscene = false		# Это говно включает чёрные рамки
var showDialog = true		# Это отображает реплики
var cps = 30				# Символов в секунду(наверное)
var time_d_start = 0		# Счётчик для отрисовки символов

var who_speak = "sl"		# Текуший говорнун
var text_line = ""			# слова
var emotion =   "normal"	# эмоция
var dress =     "pioneer"	# одежда

var dialog : Array
var currentline = 0
var skip = true

var GapBorder = Vector2()
var TxtBorder = Vector2()

func DrawBorder(var x, var y, var w, var h):
	var c = null
	var scale = DG_Border.scale*16
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

func get_tileid(var e, var d):
	return em[e] * 10 + dr[d] 

# warning-ignore:unused_argument
func _process(delta):
	
	$FilmLines.visible = cutscene
	$GameUI.visible = !cutscene
	
	$FilmLines/Dialog.visible = showDialog
	
	if showDialog and len(dialog) != 0:
		var line = dialog[currentline]
		if line[0] == "say":
			text_line = line[2]
			who_speak = line[1]
			if time_d_start == 0:
				time_d_start = OS.get_ticks_msec()
			DG_Border.modulate = dialog_color_name[who_speak][0].linear_interpolate(DG_Border.modulate, 0.95)
			var cell_columns = 12
			var cell_rows    = 2
			$FilmLines/Dialog/Icon.set_cell(-1,-1,get_tileid(emotion, dress))
			var textdrawat = DrawBorder(cell_columns+9, cell_rows+1, cell_columns+2, cell_rows+2)
			if textdrawat != null:
				DG_Text.position = textdrawat
			var x = 0
			skip = true
			for i in range(len(text_line)):
				if float(i) / cps * 1000 > OS.get_ticks_msec() - time_d_start:
					skip = false
					break
				var tileid = charmap[text_line[i]]
				DG_Text.set_cellv(Vector2(x%((cell_columns-1)*3),x/((cell_columns-1)*3)), tileid)
				x += 1
			if skip and Input.is_action_just_pressed("d_skip"):
				currentline += 1
				time_d_start = 0
				DG_Text.clear()
	

