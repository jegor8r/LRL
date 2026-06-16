extends CharacterBody2D
#Экспорт дает возможность менять скорость разным машинам
@export var speed = 200          # скорость машины
@export var rotation_speed = 2.0 # скорость поворота
var player_nearby = false
var is_occupied = false

func _ready():
	$EntryZone.body_entered.connect(_on_player_entered)
	$EntryZone.body_exited.connect(_on_player_exited)
func _on_player_entered(body):
	if body.is_in_group("Player"):
		player_nearby = true
func _on_player_exited(body):
	if body.is_in_group("Player"):
		player_nearby = false
func enter_car(player_node):
	is_occupied = true
	player_node.visible = false
	player_node.set_physics_process(false)

func exit_car(player_node):
	is_occupied = false
	player_node.visible = true
	player_node.set_physics_process(true)
	player_node.global_position = global_position * Vector2(40, 0)
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
