extends Area2D

func _on_body_entered(body):
	if body.name == "Player":
		scale *= 1.2

func _on_body_exited(body):
	if body.name == "Player":
		scale /= 1.2
	
