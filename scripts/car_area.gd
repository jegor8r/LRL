extends Area2D

@export var damage = 30

func _on_body_entered(body):
	# проверяем что врезались именно в персонажа
	if body.has_method("take_damage"):
		body.take_damage(damage)
