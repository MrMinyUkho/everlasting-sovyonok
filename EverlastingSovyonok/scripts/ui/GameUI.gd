extends Control

var dialog_color_name = {}

const charmap = {			# О это исскуство кодинга
	"!": Vector2i(0, 0),
	".": Vector2i(1, 0),
	"?": Vector2i(2, 0),
	",": Vector2i(3, 0),
	":": Vector2i(4, 0),
	";": Vector2i(5, 0),
	"0": Vector2i(6, 0),
	"1": Vector2i(7, 0),
	"2": Vector2i(8, 0),
	"3": Vector2i(9, 0),
	"4": Vector2i(10, 0),
	"5": Vector2i(11, 0),
	"6": Vector2i(12, 0),
	"7": Vector2i(13, 0),
	"8": Vector2i(14, 0),
	"9": Vector2i(15, 0),
	"<": Vector2i(16, 0),
	">": Vector2i(17, 0),
	" ": Vector2i(25, 0),
	"А": Vector2i(0,  1), "а": Vector2i(0,  3),
	"Б": Vector2i(1,  1), "б": Vector2i(1,  3),
	"В": Vector2i(2,  1), "в": Vector2i(2,  3),
	"Г": Vector2i(3,  1), "г": Vector2i(3,  3),
	"Д": Vector2i(4,  1), "д": Vector2i(4,  3),
	"Е": Vector2i(5,  1), "е": Vector2i(5,  3),
	"Ж": Vector2i(6,  1), "ж": Vector2i(6,  3),
	"З": Vector2i(7,  1), "з": Vector2i(7,  3),
	"И": Vector2i(8,  1), "и": Vector2i(8,  3),
	"Й": Vector2i(9,  1), "й": Vector2i(9,  3),
	"К": Vector2i(10, 1), "к": Vector2i(10, 3),
	"Л": Vector2i(11, 1), "л": Vector2i(11, 3),
	"М": Vector2i(12, 1), "м": Vector2i(12, 3),
	"Н": Vector2i(13, 1), "н": Vector2i(13, 3),
	"О": Vector2i(14, 1), "о": Vector2i(14, 3),
	"П": Vector2i(15, 1), "п": Vector2i(15, 3),
	"Р": Vector2i(16, 1), "р": Vector2i(16, 3),
	"С": Vector2i(17, 1), "с": Vector2i(17, 3),
	"Т": Vector2i(18, 1), "т": Vector2i(18, 3),
	"У": Vector2i(19, 1), "у": Vector2i(19, 3),
	"Ф": Vector2i(20, 1), "ф": Vector2i(20, 3),
	"Х": Vector2i(21, 1), "х": Vector2i(21, 3),
	"Ц": Vector2i(22, 1), "ц": Vector2i(22, 3),
	"Ч": Vector2i(23, 1), "ч": Vector2i(23, 3),
	"Ш": Vector2i(24, 1), "ш": Vector2i(24, 3),
	"Щ": Vector2i(25, 1), "щ": Vector2i(25, 3),
	"Ъ": Vector2i(0,  2), "ъ": Vector2i(0,  4),
	"Ы": Vector2i(1,  2), "ы": Vector2i(1,  4),
	"Ь": Vector2i(2,  2), "ь": Vector2i(2,  4),
	"Э": Vector2i(3,  2), "э": Vector2i(3,  4),
	"Ю": Vector2i(4,  2), "ю": Vector2i(4,  4),
	"Я": Vector2i(5,  2), "я": Vector2i(5,  4),
}

const em = {
	"normal": 0,
}

const dr = {
	"pioneer": 0,
}

@onready var DG_Border = get_node("./FilmLines/Dialog/DialogBorder")
@onready var DG_Text   = get_node("./FilmLines/Dialog/Text")
@onready var Glob      = get_node("/root/Global")

var Scene = Node2D

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
	var scales = DG_Border.scale*16
	for i in range(w):
		for j in range(h):				# Тут где-то ошибка, но её можно скрыть
			var tid = Vector2i(1,1)		# просто рисуя рамку ниже краёв экрана :D
			if i + j == 0:
				tid = Vector2i(0,0)
			elif j == h - 1 and i == 0:
				tid = Vector2i(0,2)
			elif i == w - 1 and j == 0:
				tid = Vector2i(2,0)
			elif i == h - 1 and j == w - 1:
				tid = Vector2i(2,2)
			elif i == w - 1:
				tid = Vector2i(2,1)
			elif j == h - 1:
				tid = Vector2i(1,2)
			elif j == 0:
				tid = Vector2i(1,0)
			elif i == 0:
				tid = Vector2i(0,1)
			else:
				if c == null:
					c = Vector2((-x+i)*scales.x, (-y+j)*scales.y)
				tid = Vector2i(1,1)
			DG_Border.set_cell(0 , Vector2i(-x+i, -y+j), 0, tid)
	return c

func draw_choice(x, y, l, ln):
	var scales = DG_Border.scale*16
	var c = {}
	DG_Text.position = Vector2(-x*scales.x, (-y+0.25)*scales.y)
	for i in range(len(l)):
		for j in range(ln):
			var tid = Vector2i(1, 3)
			if j == 0:
				tid = Vector2i(0, 3)
			elif j == ln - 1:
				tid = Vector2i(2, 3)
			DG_Border.set_cell(0, Vector2(-x+j, -y+i), 0, tid)
		var cc = 0
		for j in l[i]:
			DG_Text.set_cell(0, Vector2(cc+1, i*2), 0, charmap[j])
			cc+=1
		c[l[i]] = [Vector2(0, i*scale.y), Vector2(ln*scales.x, (i+1)*scales.y)]
	return c

func get_tileid(e, d):			# Это говно в душе не чаю как будет работать
	return em[e] * 10 + dr[d]	# до того момента пока все авы не будут сделаны

func _ready():
	Scene = get_tree().current_scene
	if OS.get_name() == "Android":
		$"Virtual Joystick".visible = true

func _process(_delta):
	
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
			$FilmLines/Dialog/Icon.set_cell(0, Vector2i(-1,-1), 0, Vector2i(em[emotion], dr[dress]))
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
				@warning_ignore("integer_division")
				DG_Text.set_cell(0, Vector2i(x%((cell_columns-2)*3+2),x/((cell_columns-2)*3+2)), 0, tileid)
				x += 1
			if skip and Input.is_action_just_pressed("d_skip"):
				currentline += 1
				time_d_start = 0
				DG_Text.clear()
		elif line[0] == "choice":
			DG_Border.modulate = dialog_color_name["me"][0].lerp(DG_Border.modulate, 0.95)
			var cell_columns = 12
			var cell_rows = len(line[1])
			$FilmLines/Dialog/Icon.set_cell(0, Vector2i(-1,-1), 0, Vector2i(em[emotion], dr[dress]))
			var b = DrawBorder(cell_columns+9, cell_rows+1, cell_columns+2, cell_rows+2)
			var chs = draw_choice(cell_columns+8, cell_rows, line[2], cell_columns)
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
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
						Glob.NPC_signal(null, "choice:"+line[1][ind])
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
		elif line[0] == "edvar":
			Glob.NPC_signal(null, ["edvar", line[1], line[2]])
			currentline+=1
		elif line[0] == "end":
			Glob.NPC_signal(null, ["end_dialog"])
			
			
