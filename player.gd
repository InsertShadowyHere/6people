# In your CharacterBody3D script
extends CharacterBody3D

@export var mouse_sensitivity = 0.002 # radians/pixel
@export var speed = 8
@export var jump_velocity = 4.5
@export var gravity = 75
var target_velocity = Vector3.ZERO


@onready var camera = $Camera

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)

func _physics_process(delta):
	# We create a local variable to store the input direction.
	var direction = Vector3.ZERO

	# We check for each move input and update the direction accordingly.
	if Input.is_action_pressed("right"):
		direction.x += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1
	if Input.is_action_pressed("backward"):
		# Notice how we are working with the vector's x and z axes.
		# In 3D, the XZ plane is the ground plane.
		direction.z += 1
	if Input.is_action_pressed("forward"):
		direction.z -= 1
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		direction = Basis.looking_at(direction)
	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		target_velocity.y = target_velocity.y - (gravity * delta)

	# Moving the Character
	velocity = target_velocity
	move_and_slide()
