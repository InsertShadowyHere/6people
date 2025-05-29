extends Area2D

signal opened(object_type, action)

func _on_body_entered(body):
	if body.name == "Player":
		emit_signal("opened", self.name)  # Example interaction
