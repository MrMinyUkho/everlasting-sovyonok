extends KinematicBody2D

var dir = Vector2(1, 0)
var vel = 7.5

var InDialog = false
var DialogTarget = null

func _ready():
	pass

func _process(delta):
	
	# Передвижение
	
	if Input.is_action_pressed("move_down"):
		dir.y = 1
	else:
		dir.y = 0
		if Input.is_action_pressed("move_up"):
			dir.y = -1
		else:
			dir.y = 0
	if Input.is_action_pressed("move_left"):
		dir.x = -1
	else:
		dir.x = 0
		if Input.is_action_pressed("move_right"):
			dir.x = 1
		else:
			dir.x = 0
			
	if Input.is_action_pressed("move_walk"):
		vel = 6
		$AnimatedSprite.speed_scale = 1
	else:
		vel = 12
		$AnimatedSprite.speed_scale = 1.5
	
	if InDialog == true:
		if ((DialogTarget.position.x - self.position.x < -OS.get_window_size().x*0.7 and dir.x > 0) 
		 or (DialogTarget.position.x - self.position.x > OS.get_window_size().x*0.7 and dir.x < 0)):
			dir.x = 0
		if((DialogTarget.position.y - self.position.y + 64*self.scale.y < -OS.get_window_size().y*0.7 and dir.y > 0) 
		 or (DialogTarget.position.y - self.position.y + 64*self.scale.y > OS.get_window_size().y*0.7 and dir.y < 0)):
			dir.y = 0
	
	dir = dir.normalized()
	
# warning-ignore:return_value_discarded
	self.move_and_slide(dir*vel*delta*1000)
	# Анимации ходьбы
	if dir == Vector2(0, 0):
		$AnimatedSprite.frame = 0
		$AnimatedSprite.playing = false
	else:
		if dir.x > 0:
			$AnimatedSprite.play("SamePerson_Right")
		elif dir.x < 0:
			$AnimatedSprite.play("SamePerson_Left")
		else:
			if dir.y > 0:
				$AnimatedSprite.play("SamePerson_Down")
			elif dir.y < 0:
				$AnimatedSprite.play("SamePerson_Up")
		
	
		
	
