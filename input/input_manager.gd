# InputManager autoload
extends Node


#region Properties
## Whether the project window is currently focused.
var focused := true

## Events that should be scoped to a specific player.
var _controller_events = [
	Model.Action.MOVE_LEFT,
	Model.Action.MOVE_RIGHT,
	Model.Action.MOVE_UP,
	Model.Action.MOVE_DOWN,
	Model.Action.SELECT,
]

## Format string to create per-player actions.
var _custom_action_format = '%s_%d'

## Array to track which players have been allocated.
var _player_is_active = [false, false, false, false]
#endregion


#region Builtins
func _notification(notification_type: int) -> void:
	match notification_type:
		NOTIFICATION_APPLICATION_FOCUS_IN:
			focused = true
		NOTIFICATION_APPLICATION_FOCUS_OUT:
			focused = false

func _ready() -> void:
	# Set up input mappings for each player
	for player_id in range(Config.MAX_PLAYER_COUNT):
		for action_name in _controller_events:
			# Create a custom input event for just this player
			var custom_action = adapt_action(action_name, player_id)
			InputMap.add_action(custom_action)
			for event in InputMap.action_get_events(action_name):
				var custom_event = event.duplicate()
				custom_event.set_device(player_id)
				InputMap.action_add_event(custom_action, custom_event)
#endregion


#region Utilities
func get_controller_manager() -> PlayerInputManager:
	for i in range(Config.MAX_PLAYER_COUNT):
		if not _player_is_active[i]:
			_player_is_active[i] = true
			return PlayerInputManager.new(i)

	## We should never hit this code, crash the game (since this is a prototype)
	assert(false)
	return PlayerInputManager.new(-1)

func adapt_action(action: StringName, player_id: int) -> StringName:
	return _custom_action_format % [action, player_id]
#endregion
