extends CharacterBody2D

@export var speed = 500
var bg_node
var bg_size

var pos

var SCREEN_SIZE = Vector2(1152, 648)
var coords = SCREEN_SIZE/2
var edge_buffer = 30

const zero_vector = Vector2(0, 0)

func _ready() -> void:
	var camera = $PlayerCam
	bg_node = get_parent().get_node("World").get_node("Background")
	bg_size = Vector2(bg_node.texture.get_width(), bg_node.texture.get_height()) * bg_node.scale
	position = SCREEN_SIZE/2
	camera.limit_left = 0
	camera.limit_right = bg_size[0]
	camera.limit_top = 0
	camera.limit_bottom = bg_size[1]
	
func _process(delta: float) -> void:
	velocity = zero_vector # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

	position[0] = clamp(position[0] + velocity[0]*delta,	edge_buffer, bg_size[0]-edge_buffer)
	position[1] = clamp(position[1] + velocity[1]*delta, edge_buffer, bg_size[1]-edge_buffer)
