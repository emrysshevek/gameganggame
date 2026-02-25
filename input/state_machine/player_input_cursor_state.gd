class_name PlayerInputCursorState
extends PlayerInputState


func _ready() -> void:
	state = PlayerInputStateMachine.States.CURSOR
	

func update(_delta: float) -> void:
	if player_input_manager.is_action_just_pressed(Model.Action.TOGGLE_MAP):
		finished.emit(CARD)
	pass
