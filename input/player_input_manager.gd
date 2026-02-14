class_name PlayerInputManager
extends Node


#region Properties
var _controller_id: int
#endregion


#region Builtins
func _init(controller_id: int) -> void:
	_controller_id = controller_id
#endregion


#region Input Overrides
func get_axis_h() -> float:
	# Ignore inputs if the project isn't focused
	if not InputManager.focused:
		return false
	return Input.get_axis(
		InputManager.adapt_action(Model.Action.MOVE_LEFT, _controller_id),
		InputManager.adapt_action(Model.Action.MOVE_RIGHT, _controller_id)
	)

func get_axis_v() -> float:
	# Ignore inputs if the project isn't focused
	if not InputManager.focused:
		return false
	return Input.get_axis(
		InputManager.adapt_action(Model.Action.MOVE_UP, _controller_id),
		InputManager.adapt_action(Model.Action.MOVE_DOWN, _controller_id)
	)

## Custom wrapper for Input.get_vector.
func get_vector() -> Vector2:
	# Ignore inputs if the project isn't focused
	if not InputManager.focused:
		return Vector2(0, 0)
	return Input.get_vector(
		InputManager.adapt_action(Model.Action.MOVE_LEFT, _controller_id),
		InputManager.adapt_action(Model.Action.MOVE_RIGHT, _controller_id),
		InputManager.adapt_action(Model.Action.MOVE_UP, _controller_id),
		InputManager.adapt_action(Model.Action.MOVE_DOWN, _controller_id)
	)

## Custom wrapper for Input.is_action_pressed.
func is_action_pressed(action: StringName) -> bool:
	# Ignore inputs if the project isn't focused
	if not InputManager.focused:
		return false
	return Input.is_action_pressed(InputManager.adapt_action(action, _controller_id))
#endregion


#region Helpers
## Flattens the output of Input.get_vector to the nearest cardinal direction.
## If no current input, will return Direction.None
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
#endregion
