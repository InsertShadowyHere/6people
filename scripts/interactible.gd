extends Area2D

signal interacted(object_type, action)

func _on_body_entered(body):
	if body.name == "Player":
		emit_signal("interacted", self.name)  # Example interaction
