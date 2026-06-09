extends CharacterBody2D

var speed = 200          # скорость машины
var rotation_speed = 2.0 # скорость поворота

func _physics_process(delta):
	var input = Vector2.ZERO
	
	# газ и тормоз
	if Input.is_action_pressed("ui_up"):
		input.y = -1
	if Input.is_action_pressed("ui_down"):
		input.y = 1
	
	# поворот
	if Input.is_action_pressed("ui_left"):
		rotation -= rotation_speed * delta
	if Input.is_action_pressed("ui_right"):
		rotation += rotation_speed * delta
	
	# движение вперёд по направлению машины
	velocity = transform.x * input.y * speed * -1
	move_and_slide()
