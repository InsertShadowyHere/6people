extends TextureProgressBar

func update() -> void:
	value = 100*PlayerData.health/PlayerData.max_health
