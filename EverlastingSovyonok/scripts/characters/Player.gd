extends CharacterBody2D

var vel
var dir = Vector2.ZERO

var InDialog = false
var DialogTarget = null

func _physics_process(_delta):
	# Передвижение
	dir = Vector2.ZERO
	if Input.is_action_pressed("move_down"):
		dir.y += 1
	if Input.is_action_pressed("move_up"):
		dir.y += -1
	if Input.is_action_pressed("move_right"):
		dir.x += 1
	if Input.is_action_pressed("move_left"):
		dir.x += -1
	
	# Медленная ходьба(в катсцене - постоянная)
	if Input.is_action_pressed("move_walk") or InDialog:
		vel = 6
		$AnimatedSprite2D.speed_scale = 1
	else:
		vel = 12
		$AnimatedSprite2D.speed_scale = 1.5
	
		# Ограничение дальности ходьбы относительно NPC в катсцене
	if InDialog == true:
		var winsize = get_window().get_size()*0.7
		winsize.y *= 0.8
		var diffpos = DialogTarget.position - self.position
		if ((diffpos.x < -winsize.x and dir.x > 0)
		or (diffpos.x >  winsize.x and dir.x < 0)):
			dir.x = 0
		if ((diffpos.y < -winsize.y and dir.y > 0)
		or (diffpos.y >  winsize.y and dir.y < 0)):
			dir.y = 0
	
	dir = dir.normalized() # нормализация движения по диагонали
	self.set_velocity(dir*vel*17)
	self.move_and_slide()

func _process(_delta):
	
	# Анимации ходьбы
	if dir == Vector2(0, 0):
		$AnimatedSprite2D.frame = 0
		$AnimatedSprite2D.stop()
	else:
		if dir.x > 0:
			$AnimatedSprite2D.play("SamePerson_Right")
		elif dir.x < 0:
			$AnimatedSprite2D.play("SamePerson_Left")
		else:
			if dir.y > 0:
				$AnimatedSprite2D.play("SamePerson_Down")
			elif dir.y < 0:
				$AnimatedSprite2D.play("SamePerson_Up")
	
