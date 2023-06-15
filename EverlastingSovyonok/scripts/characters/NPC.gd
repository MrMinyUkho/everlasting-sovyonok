extends CharacterBody2D

@onready var Glob = get_node("/root/Global")

var dir = Vector2(0, 0)
var vel = 0

var state = "idle"
var target = null
var inDialog = false
var stopon = 0
var startat = 0

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
		if startat is String:
			startat = 100000
		if dir.length() < startat:
			vel = 10
		if dir.length() < stopon:
			Glob.NPC_signal(whoami, "stop")
			state = "idle"
			velocity = Vector2.ZERO
	
	if state == "move":
		vel = 10
		if dir.lenght() < 5:
			state = "idle"
			vel = 0
	if state == "idle":
		if target != null:
			var vec_to_target = -(self.global_position - target.global_position).normalized()
			if vec_to_target.x > 0.3:
				$AnimatedSprite2D.play("right")
			elif vec_to_target.x < -0.3:
				$AnimatedSprite2D.play("left")
			else:
				if vec_to_target.y > 0:
					$AnimatedSprite2D.play("down")
				elif vec_to_target.y < 0:
					$AnimatedSprite2D.play("up")
			$AnimatedSprite2D.frame = 0
			$AnimatedSprite2D.stop()
		velocity = Vector2.ZERO
		dir = Vector2.ZERO
	
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

func _physics_process(_delta):
	if state != "idle":
		self.set_velocity(dir.normalized()*160)
		self.move_and_slide()
