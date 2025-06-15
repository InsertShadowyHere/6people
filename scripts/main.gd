extends Node

var new_zone

func _ready() -> void:
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	#switch_zones("res://generic-objects/fragment_sample.tscn")

func switch_zones(zone):
	for child in $RenderedZone.get_children():
		child.queue_free()
	new_zone = load(zone).instantiate()
	$RenderedZone.add_child(new_zone)

# code is normal, function itself is TEMP and should not be used
# actual scene switching will likely occur based on area3d nodes or 
# interaction with doors if we add those
func _on_player_switch_zones(zone_path) -> void:
	for child in $RenderedZone.get_children():
		child.queue_free()
	new_zone = load(zone_path).instantiate()
	$RenderedZone.add_child(new_zone)
