# In your CharacterBody3D script
extends CharacterBody3D

signal looking_at_stuff(stuff)
signal not_looking_at_stuff

signal update_health

@export var mouse_sensitivity = 0.0015 # radians/pixel
@export var speed = 20
@export var jump_strength = 20
@export var gravity = 1
@export var range = 100

var viewed_object
var interactible_displayed = false

var pi_over_two = 3.1415/2

var camera_view = 1
var zoomed = false
var fov = 90

var vertical_angle = 0.0

var preserve_y_velocity
var forward
var left

var test = false

# DEBUG
const DEBUG_OBJ = preload("res://generic-objects/debug_object.tscn")
var obj

@onready var camera = $Camera
@onready var hitcaster = $Camera/Hitcaster
@onready var sightcaster = $Camera/Sightcaster

func _ready():
	camera.fov = fov
	hitcaster.scale *= range #adjusting because normal raycast scale is WAY too low
	sightcaster.scale *= 2

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		if vertical_angle - event.relative.y * mouse_sensitivity == clamp(vertical_angle - event.relative.y * mouse_sensitivity, -pi_over_two, pi_over_two):
			camera.rotate_x(-event.relative.y * mouse_sensitivity)
			vertical_angle -= event.relative.y * mouse_sensitivity
	elif Input.is_action_just_pressed("switch_camera"):
		if camera_view == 1:
			camera_view = 2
			camera.position[2] += 5
			camera.position[1] += 2
		else:
			camera_view = 1
			camera.position[2] -= 5
			camera.position[1] -= 2
	elif Input.is_action_just_pressed("zoom"):
		if zoomed == true:
			mouse_sensitivity *= 3
			zoomed = false
			camera.fov = fov
		else:
			mouse_sensitivity /= 3
			zoomed = true
			camera.fov = 30
	elif Input.is_action_just_pressed("fire") and hitcaster.is_colliding():
		if hitcaster.get_collider().is_in_group("destructible"):
			hitcaster.get_collider().queue_free()
	elif Input.is_action_just_pressed("interact") and sightcaster.is_colliding():
		if sightcaster.get_collider().has_method("interact"):
			sightcaster.get_collider().interact()
	elif Input.is_action_just_pressed("exit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("debug"):
		obj = DEBUG_OBJ.instantiate()
		obj.global_transform.origin = global_transform.origin - $Camera.global_basis.z.normalized() * 5
		get_tree().current_scene.add_child(obj)
	
func _process(delta: float) -> void:
	if interactible_displayed == false:
		if sightcaster.is_colliding():
			viewed_object = sightcaster.get_collider()
			if viewed_object.is_in_group("interactive"):
				emit_signal("looking_at_stuff", viewed_object)
				interactible_displayed = true
	elif interactible_displayed and not sightcaster.is_colliding():
		interactible_displayed = false
		emit_signal("not_looking_at_stuff")

func _physics_process(delta):
	velocity = Vector3(0, velocity[1], 0)
	forward = -$Camera.global_basis.z
	forward = Vector3(forward[0], 0, forward[2]).normalized()
	left = Vector3(-forward[2], 0, forward[0]).normalized()
	
	# Take inputs
	if Input.is_action_pressed("forward"):
		velocity += forward
	if Input.is_action_pressed("backward"):
		velocity -= forward
	if Input.is_action_pressed("left"):
		velocity -= left
	if Input.is_action_pressed("right"):
		velocity += left

	preserve_y_velocity = velocity[1]
	velocity[1] = 0
	velocity = velocity.normalized() * speed
	velocity[1] = preserve_y_velocity
	
	if Input.is_action_pressed("jump") and is_on_floor():
			velocity[1] = jump_strength
	
	velocity[1] -= gravity
	move_and_slide()

func damage(dmg):
	PlayerData.health -= dmg
	emit_signal("update_health")
	
