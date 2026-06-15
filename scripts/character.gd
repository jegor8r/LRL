extends CharacterBody2D
@export var max_health = 100
@export var health = 100
@export var speed = 100
@export var stamina = 100
@export var max_stamina = 100

# получаем узел AnimatedSprite2D
@onready var sprite = $AnimatedSprite2D
#Ходьба
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
		
	var current_speed = speed
	if Input.is_key_pressed(KEY_SHIFT) and stamina > 0:
		current_speed = speed * 3
		stamina -= 10 * delta
		stamina = max(stamina, 0)
	else:
		stamina += 10 * delta
		stamina = min(stamina, max_stamina)
	velocity = current_speed * direction
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

# Функции здоровья и урона
func take_damage(amount):
	health -=amount
	print("HP:", health)
	blink_damage()
	if health <= 0:
		die()
# НАДО ДОДЕЛАТЬ!!!
#Функция исцеления здоровья
func heal():
	await get_tree().create_timer(5.0).timeout
	while health < max_health:         
		health = min(health +5, max_health)
		await blink_heal()
	return
#Функция смерти
func die():
	print("You died!")
	queue_free()
func blink_damage(): #Функция моргания (для получения урона)
	for i in range(3):
		sprite.modulate = Color(1, 0, 0, 0.5)
		await get_tree().create_timer(0.1).timeout
		sprite.modulate = Color(1, 1, 1)
		await get_tree().create_timer(0.1).timeout
func blink_heal():   #Функция моргания (Для востановления хп)
	for p in range(2):
		sprite.modulate = Color(0, 1, 0, 0.5)
		await  get_tree().create_timer(0.1).timeout
		sprite.modulate = Color(1, 1, 1)
		await get_tree().create_timer(0.1).timeout
