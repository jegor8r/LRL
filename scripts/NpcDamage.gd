extends Area2D
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Car"):
		body.take_damage(30)
