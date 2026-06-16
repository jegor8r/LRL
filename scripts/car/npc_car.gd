extends CharacterBody2D
@export var speed = 300
@export var waypoints : Array[Vector2] = []
@export var waypoint_threshold = 10.0
var current_waypoint_index = 0
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
	player_node.global_position = global_position + Vector2(40, 0)

func _physics_process(delta):
	if is_occupied:
		# управление игрока
		if Input.is_action_pressed("ui_up"):
			velocity = transform.x * speed * 1
		elif Input.is_action_pressed("ui_down"):
			velocity = transform.x * (speed * 0.5) * -1
		else:
			velocity = Vector2.ZERO
		if Input.is_action_pressed("ui_left"):
			rotation -= 2.0 * delta
		if Input.is_action_pressed("ui_right"):
			rotation += 2.0 * delta
		move_and_slide()
		return  # ← важно! НПС логика ниже не выполняется

	# НПС логика — только если игрок НЕ внутри
	if waypoints.is_empty():
		return
	var target = waypoints[current_waypoint_index]
	var direction = (target - global_position)
	if direction.length() < waypoint_threshold:
		current_waypoint_index = (current_waypoint_index + 1) % waypoints.size()
		return
	var target_angle = direction.angle()
	rotation = lerp_angle(rotation, target_angle, delta * 3.0)
	velocity = transform.x * speed * -1
	move_and_slide()
