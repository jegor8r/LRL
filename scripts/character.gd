extends CharacterBody2D
@export var max_health = 100
@export var health = 100
@export var speed = 150

# получаем узел AnimatedSprite2D
@onready var sprite = $AnimatedSprite2D

func _physics_process(delta):
	var direction = Vector2.ZERO
	
	# считываем ввод
	if Input.is_action_pressed("ui_up"):
		direction.y = -1
	if Input.is_action_pressed("ui_down"):
		direction.y = 1
	if Input.is_action_pressed("ui_left"):
		direction.x = -1
	if Input.is_action_pressed("ui_right"):
		direction.x = 1
	
	# двигаем персонажа
	velocity = direction * speed
	move_and_slide()
	
	# анимации
	if direction == Vector2.ZERO:
		sprite.play("Idle")
	elif direction.y < 0:
		sprite.play("Walk_up")
	elif direction.y > 0:
		sprite.play("Walk_down")
	elif direction.x < 0:
		sprite.play("Walk_left")
	elif direction.x > 0:
		sprite.play("Walk_right")
func take_damage(amount):
	health -=amount
	print("HP:", health)
	if health <= 0:
		die()
func die():
	print("You died!")
	queue_free()
