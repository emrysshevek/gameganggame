# InputManager autoload
extends Node


#region Properties
## Whether the project window is currently focused.
var _focused := true
#endregion


#region Methods
func _notification(notification_type: int) -> void:
	match notification_type:
		NOTIFICATION_APPLICATION_FOCUS_IN:
			_focused = true
		NOTIFICATION_APPLICATION_FOCUS_OUT:
			_focused = false

func get_axis_h() -> float:
	# Ignore inputs if the project isn't focused
	if not _focused:
		return false
	return Input.get_axis("move_left", "move_right")

func get_axis_v() -> float:
	# Ignore inputs if the project isn't focused
	if not _focused:
		return false
	return Input.get_axis("move_up", "move_down")

func get_vector() -> Vector2:
	# Ignore inputs if the project isn't focused
	if not _focused:
		return Vector2(0, 0)
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")

func get_direction() -> Model.Direction:
	var input = get_vector()
	if input.x == 0 and input.y == 0:
		# No current input
		return Model.Direction.NONE
	if abs(input.x) >= abs(input.y):
		# Choose between left/right
		return Model.Direction.LEFT if input.x < 0 else Model.Direction.RIGHT
	else:
		# Choose between up/down
		return Model.Direction.UP if input.y < 0 else Model.Direction.DOWN

func is_action_pressed(action: StringName) -> bool:
	# Ignore inputs if the project isn't focused
	if not _focused:
		return false
	return Input.is_action_pressed(action)
#endregion
