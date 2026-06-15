extends CharacterBody2D

@export var speed = 50
@export var run_speed = 100
@export var health = 100
@onready var sprite = $AnimatedSprite2D

var target_position = Vector2.ZERO
var is_running = false

#Функция выбора рандомной точки
func pick_random_target():
	target_position = global_position + Vector2(
		randf_range(-300, 300),
		randf_range(-300, 300)
	)
#Логика ходьбы и выбора точки
func move_to_target():
	var direction = (target_position - global_position).normalized()
	var distance = global_position.distance_to(target_position)
	if distance < 10:
		pick_random_target()
		return #После ретурна функция возращается
	var current_speed = run_speed if is_running else speed
	velocity = direction * current_speed
	move_and_slide()
	update_animation(direction)
#Анимация ходьбы и ожидания
func update_animation(direction):
	if velocity == Vector2.ZERO:
		sprite.play("Idle")
	elif direction.y < 0:
		sprite.play("Walk_up")
	elif  direction.y > 0:
		sprite.play("Walk_down")
	elif direction.x > 0:
		sprite.play("Walk_right")
	elif direction.x < 0:
		sprite.play("Walk_left")
#Функция получение урона
func take_damage(amount):
	if health - amount:
		blink()
		health -= amount
		is_running = true
		pick_random_target()
		await get_tree().create_timer(3.0).timeout
		is_running = false
		if health <= 0:
			queue_free()
#Функция моргания
func blink():
	for i in range(3):
		sprite.modulate = Color(1, 0, 0, 0.5)
		await  get_tree().create_timer(0.5).timeout
		sprite.modulate = Color(1, 1, 1)
		await get_tree().create_timer(0.5).timeout
#Вызываем функции
func _ready():
	await get_tree().create_timer(0.5).timeout
	pick_random_target()
func _physics_process(delta):
	move_to_target()
