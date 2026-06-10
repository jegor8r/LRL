extends CharacterBody2D

@export var speed = 50
@export var run_speed = 100
@export var health = 100
@onready var sprite = $AnimatedSprite2D

var target_position = Vector2.ZERO
var is_running = false
func pick_random_target():
	target_position = global_position + Vector2(
		randf_range(-300, 300),
		randf_range(-300, 300)
	)
func move_to_target():
	var direction = (target_position - global_position).normalized()
	var distance = global_position.distance_to(target_position)
	if distance < 10:
		pick_random_target()
		return
		var current_speed = run_speed if is_running else speed
		velocity = direction * current_speed
		move_and_slide()
		update_animation(direction)
func update_animation(direction):
	if velocity == Vector2.ZERO:
		sprite.play("Idle")
	elif direction.y < 0:
		sprite.play("Walk_left")
	elif  direction.y > 0:
		sprite.play("walk_right")
	elif direction.x > 0:
		sprite.play("Walk_up")
	elif direction.x < 0:
		sprite.play("Walk_down")
		
func _ready():
	pick_random_target()
func _physics_process(delta):
	move_to_target()

func take_damage(amount):
	health -= amount
	blink()
	is_running = true
	pick_random_target()
	await get_tree().create_timer(3.0).timeout
	is_running = false
	if health <= 0:
		queue_free()
func blink():
	for i in range(3):
		sprite.modulate = Color(1, 0, 0, 0.5)
		await  get_tree().create_timer(0.5).timeout
		sprite.modulate = Color(1, 1, 1)
		await get_tree().create_timer(0.5).timeout
