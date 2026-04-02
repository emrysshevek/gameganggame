class_name ValuesViewerTest
extends Control


var _input_manager: PlayerInputManager

var _value_manager: ValueManager


func _ready() -> void:
	_input_manager = InputManager.get_player_input_manager(0)
	_value_manager = Utils.try_get_value_manager()


func _process(_delta: float) -> void:
	# Test - bind MOVE_LEFT to use random value
	if _input_manager.is_action_just_released(Model.Action.MOVE_LEFT):
		_value_manager.use_value(Utils.get_random_value())
	# Test - bind MOVE_RIGHT to gain random value
	if _input_manager.is_action_just_released(Model.Action.MOVE_RIGHT):
		_value_manager.gain_value(Utils.get_random_value())
