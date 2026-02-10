class_name InputTest
extends ColorRect


func _physics_process(_delta: float) -> void:
	var direction = InputManager.get_direction()
	match direction:
		Model.Direction.LEFT:
			color = Color.HOT_PINK
		Model.Direction.RIGHT:
			color = Color.DEEP_SKY_BLUE
		Model.Direction.UP:
			color = Color.MEDIUM_PURPLE
		Model.Direction.DOWN:
			color = Color.MEDIUM_SEA_GREEN
		_:
			color = Color.FLORAL_WHITE

	if InputManager.is_action_pressed("select"):
		color = Color.GOLD
