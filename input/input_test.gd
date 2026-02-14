class_name InputTest
extends ColorRect


@export
var player_id := -1

@onready
var _input_manager: PlayerInputManager = InputManager.get_controller_manager(player_id)


func _physics_process(_delta: float) -> void:
	var direction = _input_manager.get_direction()
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

	if _input_manager.is_action_pressed(Model.Action.SELECT):
		color = Color.GOLD
