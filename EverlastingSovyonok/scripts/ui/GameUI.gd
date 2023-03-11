extends Control

var dialog_color_name = {}

const charmap = {			# О это исскуство кодинга
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

@onready var DG_Border = get_node("./FilmLines/Dialog/DialogBorder")
@onready var DG_Text   = get_node("./FilmLines/Dialog/Text")


# Переменные для для диалогов
var cutscene = false		# Это говно включает чёрные рамки
var showDialog = true		# Это отображает реплики
var cps = 30				# Символов в секунду(наверное)
var time_d_start = 0		# Счётчик для отрисовки символов

var who_speak = "sl"		# Текуший говорнун
var text_line = ""			# слова
var emotion =   "normal"	# эмоция
var dress =     "pioneer"	# одежда

var dialog : Array			# Тут текущий диалог
var currentline = 0			# Текущая строка
var skip = true				# Это возможность скипа
var labels : Dictionary		# Лейблы для скачков между диалогами

var vars : Dictionary		# Это копия переменных из парсера
							# да это костыль и мне насрать

# Переменные для нормальной роботы выборов(не политические)
var ChoiceBoxes : Dictionary

var GapBorder = Vector2()
var TxtBorder = Vector2()

func gen_label():
	for i in range(len(dialog)):
		if dialog[i][0] == "lb":
			labels[dialog[i][1]] = i

func DrawBorder(x, y, w, h):
	var c = null
	var scale = DG_Border.scale*16
	for i in range(w):
		for j in range(h):			# Тут где-то ошибка, но её можно скрыть
			var tid = 4				# просто рисуя рамку ниже краёв экрана :D
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

func draw_choice(x, y, l, ln):
	var scale = DG_Border.scale*16
# warning-ignore:unassigned_variable
	var c : Dictionary
	DG_Text.position = Vector2(-x*scale.x, (-y+0.25)*scale.y)
	for i in range(len(l)):
		for j in range(ln):
			var tid = 10
			if j == 0:
				tid = 9
			elif j == ln - 1:
				tid = 11
			DG_Border.set_cell(-x+j, -y+i, tid)
		var cc = 0
		for j in l[i]:
			DG_Text.set_cell(cc+1, i*2, charmap[j])
			cc+=1
		c[l[i]] = [Vector2(0, i*scale.y), Vector2(ln*scale.x, (i+1)*scale.y)]
	return c

func get_tileid(e, d):	# Это говно в душе не чаю как будет работать
	return em[e] * 10 + dr[d]	# до того момента пока все авы не будут сделаны

# warning-ignore:unused_argument
func _process(delta):
	
	$FilmLines.visible = cutscene
	$GameUI.visible = !cutscene
	
	$FilmLines/Dialog.visible = showDialog
	
	if showDialog and len(dialog) != 0:
		var line = dialog[currentline]
		if line[0] == "say":				# Это страшилище уже не помню как
			text_line = line[2]				# работает, но оно рисует диалог
			who_speak = line[1]
			if time_d_start == 0:
				time_d_start = Time.get_ticks_msec()
			DG_Border.modulate = dialog_color_name[who_speak][0].lerp(DG_Border.modulate, 0.95)
			var cell_columns = 12
			var cell_rows    = 2
			$FilmLines/Dialog/Icon.set_cell(-1,-1,get_tileid(emotion, dress))
			var textdrawat = DrawBorder(cell_columns+9, cell_rows+1, cell_columns+2, cell_rows+2)
			if textdrawat != null:
				DG_Text.position = textdrawat
			var x = 0
			skip = true
			for i in range(len(text_line)):
				if float(i) / cps * 1000 > Time.get_ticks_msec() - time_d_start:
					skip = false
					break
				var tileid = charmap[text_line[i]]
				DG_Text.set_cellv(Vector2(x%((cell_columns-1)*3),x/((cell_columns-1)*3)), tileid)
				x += 1
			if skip and Input.is_action_just_pressed("d_skip"):
				currentline += 1
				time_d_start = 0
				DG_Text.clear()
		elif line[0] == "choice":
			DG_Border.modulate = dialog_color_name["me"][0].lerp(DG_Border.modulate, 0.95)
			var cell_columns = 12
			var cell_rows = len(line[1])
			$FilmLines/Dialog/Icon.set_cell(-1,-1,get_tileid(emotion, dress))
			var b = DrawBorder(cell_columns+9, cell_rows+1, cell_columns+2, cell_rows+2)
			var chs = draw_choice(cell_columns+8, cell_rows, line[2], cell_columns)
			if Input.is_mouse_button_pressed(1):
				for i in chs:
					var c = chs[i]
					c[0].x+=b.x
					c[0].y+=b.y
					c[1].x+=b.x
					c[1].y+=b.y
					var mp = $FilmLines/Dialog.get_local_mouse_position()
					if (mp.x > c[0].x) and (mp.x < c[1].x) and \
					   (mp.y > c[0].y) and (mp.y < c[1].y):
						var ind = line[2].find(i)
						var sc = get_tree().current_scene
						if !sc.NPCs_signals.has("me"):
							sc.NPCs_signals["me"] = []
						sc.NPCs_signals["me"].append("choice:"+line[1][ind])
						currentline+=1
						DG_Text.clear()
		elif line[0] == "goto":
			if labels.has(line[1]):
				currentline = labels[line[1]]
		elif line[0] == "gotoc":
			var jump = false
			for i in line[2]:
				if "=" in i:
					var c = i.split("=")
					if vars[c[0]] == int(c[1]):
						jump = true
				elif ">" in i:
					var c = i.split(">")
					if vars[c[0]] > int(c[1]):
						jump = true
				elif "<" in i:
					var c = i.split("<")
					if vars[c[0]] < int(c[1]):
						jump = true
			if jump:
				currentline=labels[line[1]]
			else:
				currentline=labels[line[3]]
		elif line[0] == "lb":
			currentline+=1
