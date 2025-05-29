extends Control
func _ready():
	size[0] = 1000
	size[1] = 100
	# Set anchors to stretch across the screen
	anchor_left = 0.0  # Left edge of the screen
	anchor_top = 0.0   # Top edge of the screen
	anchor_right = 1.0 # Right edge of the screen
	anchor_bottom = 1.0 # Bottom edge of the screen
