extends Control

var interact_label

func _ready():
	interact_label = $InteractLabel
	interact_label.visible = false
	
func _on_player_looking_at_stuff(stuff: Variant) -> void:
	interact_label.visible = true

func _on_player_not_looking_at_stuff() -> void:
	interact_label.visible = false


func _on_player_update_health() -> void:
	$HealthBar.update()
