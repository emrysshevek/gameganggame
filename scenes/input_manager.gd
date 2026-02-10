# InputManager autoload
extends Node


#region Properties
## Whether the project window is currently focused.
var _focused := true

## Events that should be scoped to a specific player.
var _controller_events = [
	'move_left', 'move_right', 'move_up', 'move_down', 'select'
]

var _custom_action_format = '%s_%d'
#endregion


#region Builtins
func _notification(notification_type: int) -> void:
	match notification_type:
		NOTIFICATION_APPLICATION_FOCUS_IN:
			_focused = true
		NOTIFICATION_APPLICATION_FOCUS_OUT:
			_focused = false

func _ready() -> void:
	# Set up input mappings for each player
	for player_id in range(Config.MAX_PLAYER_COUNT):
		for action_name in _controller_events:
			# Create a custom input event for just this player
			var custom_action = _action_to_player_action(action_name, player_id)
			InputMap.add_action(custom_action)
			for event in InputMap.action_get_events(action_name):
				var custom_event = event.duplicate()
				custom_event.set_device(player_id)
				InputMap.action_add_event(custom_action, custom_event)
#endregion


#region Input Helpers
func get_axis_h(player_id: int) -> float:
	# Ignore inputs if the project isn't focused
	if not _focused:
		return false
	return Input.get_axis(
		_action_to_player_action("move_left", player_id),
		_action_to_player_action("move_right", player_id)
	)

func get_axis_v(player_id: int) -> float:
	# Ignore inputs if the project isn't focused
	if not _focused:
		return false
	return Input.get_axis(
		_action_to_player_action("move_up", player_id),
		_action_to_player_action("move_down", player_id)
	)

func get_vector(player_id: int) -> Vector2:
	# Ignore inputs if the project isn't focused
	if not _focused:
		return Vector2(0, 0)
	return Input.get_vector(
		_action_to_player_action("move_left", player_id),
		_action_to_player_action("move_right", player_id),
		_action_to_player_action("move_up", player_id),
		_action_to_player_action("move_down", player_id)
	)

func get_direction(player_id: int) -> Model.Direction:
	var input = get_vector(player_id)
	if input.x == 0 and input.y == 0:
		# No current input
		return Model.Direction.NONE
	if abs(input.x) >= abs(input.y):
		# Choose between left/right
		return Model.Direction.LEFT if input.x < 0 else Model.Direction.RIGHT
	else:
		# Choose between up/down
		return Model.Direction.UP if input.y < 0 else Model.Direction.DOWN

func is_action_pressed(action: StringName, player_id: int) -> bool:
	# Ignore inputs if the project isn't focused
	if not _focused:
		return false
	return Input.is_action_pressed(_action_to_player_action(action, player_id))
#endregion


#region Utils
func _action_to_player_action(action: StringName, player_id: int) -> StringName:
	return _custom_action_format % [action, player_id]
#endregion
