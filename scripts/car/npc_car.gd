extends CharacterBody2D
@export var speed = 200
@export var waypoints : Array[Vector2] = []
@export var waypoint_threshold = 10.0
var current_waypoint_index = 0
func _physics_process(delta):
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
