extends CharacterBody2D

var dir = Vector2(0, 0)
var vel = 0

var state = "idle"
var target = null
var stopon = 0
var startat = 0
var signal_to_parent = ""

var whoami : String

func _ready():
	$AnimatedSprite2D.frames = load("res://characters/"+whoami+"/SpriteSheet.tres")
	$AnimatedSprite2D.animation = "left"
	$AnimatedSprite2D.frame = 0

# warning-ignore:unused_argument
func _process(_delta):
	
	# Движение по тупому - в сторону игрока
	# Здусь нужен алгоритм поиска пути!
	if target != null and state == "pursuit":
		dir = target.position - self.position
	elif target != null and state == "move":
		dir = target - self.position
	
	# Остановка на растоянии от игрока
	if state == "pursuit":
		if dir.length() < startat:
			vel = 10
		if dir.length() < stopon:
			if !get_parent().NPCs_signals.has(whoami):
				get_parent().NPCs_signals[whoami] = []
			get_parent().NPCs_signals[whoami].append(signal_to_parent)
			state = "idle"
			vel = 0
	
	if state == "move":
		vel = 10
		if dir.lenght() < 5:
			state = "idle"
			vel = 0
	
	@warning_ignore("integer_division")
	$AnimatedSprite2D.speed_scale = vel / 6
	
	
	# Анимации ходьбы
	if dir == Vector2(0,0):
		$AnimatedSprite2D.frame = 0
		$AnimatedSprite2D.stop()
	else:
		if dir.x > 0.3:
			$AnimatedSprite2D.play("right")
		elif dir.x < -0.3:
			$AnimatedSprite2D.play("left")
		else:
			if dir.y > 0:
				$AnimatedSprite2D.play("down")
			elif dir.y < 0:
				$AnimatedSprite2D.play("up")
		if vel == 0:
			$AnimatedSprite2D.frame = 0
			$AnimatedSprite2D.stop()

# warning-ignore:unused_argument
func _physics_process(_delta):
	self.set_velocity(dir.normalized()*vel*16)
	self.move_and_slide()
	dir = self.velocity
