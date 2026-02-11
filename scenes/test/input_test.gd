class_name InputTest
extends ColorRect


@export var player_id := -1


func _physics_process(_delta: float) -> void:
	var direction = InputManager.get_direction(player_id)
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

	if InputManager.is_action_pressed("select", player_id):
		color = Color.GOLD
