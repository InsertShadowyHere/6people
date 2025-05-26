extends CharacterBody2D

@export var speed = 500
var bg_node
var bg_size

var pos

var edge_buffer = 30
var left_edge
var right_edge
var top_edge
var bottom_edge

const zero_vector = Vector2(0, 0)

func _ready() -> void:
	var camera = $PlayerCam
	bg_node = get_parent().get_node("Map")
	bg_size = Vector2(bg_node.texture.get_width(), bg_node.texture.get_height()) * bg_node.scale
	camera.limit_left = bg_node.position[0]-bg_size[0]/2
	camera.limit_right = bg_node.position[0]+bg_size[0]/2
	camera.limit_top = bg_node.position[1]-bg_size[1]/2
	camera.limit_bottom = bg_node.position[1]+bg_size[1]/2
	left_edge = bg_node.position[0]-bg_size[0]/2
	right_edge = bg_node.position[0]+bg_size[0]/2
	top_edge = bg_node.position[1]-bg_size[1]/2
	bottom_edge = bg_node.position[1]+bg_size[1]/2
	
	
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
	
	position[0] = clamp(position[0] + velocity[0]*delta, left_edge+edge_buffer, right_edge-edge_buffer)
	position[1] = clamp(position[1] + velocity[1]*delta, top_edge+edge_buffer, bottom_edge-edge_buffer)
