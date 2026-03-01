# InputManager autoload
extends Node


#region Properties
const NULL_ID = -1

## Whether the project window is currently focused.
var focused := true

## Events that should be scoped to a specific player.
var _controller_events = [
	Model.Action.MOVE_LEFT,
	Model.Action.MOVE_RIGHT,
	Model.Action.MOVE_UP,
	Model.Action.MOVE_DOWN,
	Model.Action.SELECT,
	Model.Action.DESELECT,
	Model.Action.TOGGLE_MAP,
	Model.Action.TOGGLE_CURSOR,
]

## Format string to create per-player actions.
var _custom_action_format = '%s_%d'

## Mapping from controller id to input manager
var _controller_id_to_manager: Dictionary[int, PlayerInputManager] = {}

## Mapping from player id to controller id
var _player_id_to_controller: Dictionary[int, int] = {}
#endregion


#region Builtins
func _notification(notification_type: int) -> void:
	match notification_type:
		NOTIFICATION_APPLICATION_FOCUS_IN:
			focused = true
		NOTIFICATION_APPLICATION_FOCUS_OUT:
			focused = false

func _ready() -> void:
	# Until we want to require controller connections for the game to run, make
	# sure initial managers are created for MAX_PLAYER_COUNT. In the future,
	# we can use `for controller_id in Input.get_connected_joypads()` instead.
	for controller_id in range(Config.MAX_PLAYER_COUNT):
		_set_up_controller(controller_id)
	# Handle any future controller changes
	Input.joy_connection_changed.connect(_on_controller_change)
#endregion


#region Helpers
func get_player_input_manager(player_id: int, controller_id: int = NULL_ID) -> PlayerInputManager:
	if player_id in _player_id_to_controller:
		print_debug('Mapping already exists for player %d' % player_id)
		controller_id = _player_id_to_controller[player_id]
	else:
		if controller_id == NULL_ID:
			print_debug('Creating new mapping for player %d (null id provided)' % player_id)
			controller_id = _get_available_controller()
		_player_id_to_controller[player_id] = controller_id
	print_debug('Returning controller %d for player %d' % [controller_id, player_id])
	return _controller_id_to_manager[controller_id]

func adapt_action(action: StringName, player_id: int) -> StringName:
	return _custom_action_format % [action, player_id]
#endregion


#region Utilities
# Callback for Input.joy_connection_changed
# In the future, this could also trigger manual controller reassignment.
func _on_controller_change(controller_id: int, is_connection: bool) -> void:
	if is_connection:
		_set_up_controller(controller_id)

func _set_up_controller(controller_id: int) -> void:
	# Don't set up twice
	if controller_id in _controller_id_to_manager:
		return

	print_debug('Setting up input mapping for controller %d' % controller_id)

	# Set up input mappings for this controller
	for action_name in _controller_events:
		var custom_action = adapt_action(action_name, controller_id)
		InputMap.add_action(custom_action)
		for event in InputMap.action_get_events(action_name):
			var custom_event = event.duplicate()
			# Scope this input event to only this controller
			custom_event.set_device(controller_id)
			InputMap.action_add_event(custom_action, custom_event)

	# Create input manager
	var manager = PlayerInputManager.new(controller_id)
	_controller_id_to_manager[controller_id] = manager

func _get_available_controller() -> int:
	for id in _controller_id_to_manager.keys():
		if id not in _player_id_to_controller.values():
			return id
	# All controllers have already been allocated
	# If this code is reached, something bad has happened
	assert(false)
	return -1
#endregion
