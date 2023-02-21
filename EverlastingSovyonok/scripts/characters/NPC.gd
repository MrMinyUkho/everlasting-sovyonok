extends KinematicBody2D

var dir = Vector2(0, 0)
var vel = 0

var walk = false
var target = null
var stopon = 0

func _ready():
	pass

func _process(delta):
	# Передвижение
	
	dir = target.position - self.position
	
	if walk == true:
		vel = 10
		if dir.length() < stopon:
			walk = false
			vel = 0
	 
	
	
	$AnimatedSprite.speed_scale = vel / 6
			
	dir = dir.normalized()
		
# warning-ignore:return_value_discarded
	self.move_and_slide(dir*vel*delta*1000)
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
