extends RigidBody3D

var moving_up = false
var velocity = 0

func interact():
	velocity = 10
	moving_up = true

func _process(float) -> void:
	if moving_up and velocity:
		position[1] += velocity
		velocity -= 1
