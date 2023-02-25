extends KinematicBody2D

var dir = Vector2(0, 0)
var vel = 0

var state = "idle"
var target = null
var stopon = 0
var startat = 0

var whoami : String

func _ready():
	$AnimatedSprite.frames = load("res://characters/"+whoami+"/SpriteSheet.tres")
	$AnimatedSprite.animation = "left"
	$AnimatedSprite.frame = 0

func _process(delta):
	
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
			state = "idle"
			vel = 0
	
	if state == "move":
		vel = 10
		if dir.lenght() < 5:
			state = "idle"
			vel = 0
	
	dir = dir.normalized()
	
	$AnimatedSprite.speed_scale = vel / 6
	
	
	# Анимации ходьбы
	if dir == Vector2(0,0):
		$AnimatedSprite.frame = 0
		$AnimatedSprite.playing = false
	else:
		if dir.x > 0.3:
			$AnimatedSprite.play("right")
		elif dir.x < -0.3:
			$AnimatedSprite.play("left")
		else:
			if dir.y > 0:
				$AnimatedSprite.play("down")
			elif dir.y < 0:
				$AnimatedSprite.play("up")
		if vel == 0:
			$AnimatedSprite.frame = 0
			$AnimatedSprite.playing = false

func _physics_process(delta):
	dir = self.move_and_slide(dir*vel*delta*1000)
