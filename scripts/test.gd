extends ColorRect

func _ready():
	visible = 0

func _on_test_npc_body_entered(body: Node2D) -> void:
	visible = 1

func _on_test_npc_body_exited(body: Node2D) -> void:
	visible = 0
