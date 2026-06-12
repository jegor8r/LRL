extends Area2D
func _on_body_entered(body):
	if body.is_in_group("NPC"):
		body.take_damage(30)
	if body.is_in_group("Character"):
		body.take_damage(30)
