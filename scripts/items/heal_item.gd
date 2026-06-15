extends Area2D
@export var heal_amount = 30
func _ready():
	body_entered.connect(_on_body_entered)
func _on_body_entered(body):
	if body.is.in.group("Player"):
		body.heal_pickup(heal_amount)
		queue_free()
