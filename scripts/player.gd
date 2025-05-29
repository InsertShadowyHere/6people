extends CharacterBody2D

@export var speed = 2000
var bg_node
var bg_pos
var bg_size
var sprite

var pos

var nodes

var edge_buffer
var left_edge
var right_edge
var top_edge
var bottom_edge
var camera

signal interacted
signal switch

const zero_vector = Vector2(0, 0)

func _ready() -> void:
	_reset_level_things()
	get_parent().connect("switched", _reset_level_things)
	
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
	
	if Input.is_action_just_pressed("action_1"):
		scale *= 1.25
	if Input.is_action_just_pressed("action_2"):
		scale *= 0.8
	
	if Input.is_action_just_pressed("interact"):
		nodes = $Area.get_overlapping_areas()
		if nodes:
			emit_signal("interacted")
	if Input.is_action_just_pressed("switch"):
		emit_signal("switch", "res://levels/level2.tscn")
		

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	position[0] = clamp(position[0] + velocity[0]*delta, left_edge+edge_buffer, right_edge-edge_buffer)
	position[1] = clamp(position[1] + velocity[1]*delta, top_edge+edge_buffer, bottom_edge-edge_buffer)

func _reset_level_things():
	sprite = $Sprite.texture
	edge_buffer = max(sprite.get_width(), sprite.get_height())/2
	camera = $Camera
	bg_node = get_parent().get_node("Level")
	bg_pos = bg_node.position
	bg_node = bg_node.get_node("Map")
	bg_size = Vector2(bg_node.texture.get_width(), bg_node.texture.get_height()) * bg_node.scale
	camera.limit_left = bg_pos[0]-bg_size[0]/2
	camera.limit_right = bg_pos[0]+bg_size[0]/2
	camera.limit_top = bg_pos[1]-bg_size[1]/2
	camera.limit_bottom = bg_pos[1]+bg_size[1]/2
	left_edge = bg_pos[0]-bg_size[0]/2
	right_edge = bg_pos[0]+bg_size[0]/2
	top_edge = bg_pos[1]-bg_size[1]/2
	bottom_edge = bg_pos[1]+bg_size[1]/2
	
	position = bg_node.get_parent().get_node("StartLoc").position
