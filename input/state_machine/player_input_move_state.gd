class_name PlayerInputMoveState
extends PlayerInputState


var prev_state: String


func _ready() -> void:
	state = Model.InputState.MOVE


func enter(_previous_state_path: String, _data := {}) -> void:
	prev_state = _previous_state_path


func update(_delta: float) -> void:
	if player_input_manager.is_action_just_pressed(Model.Action.TOGGLE_MAP):
		finished.emit(Model.InputState.CARD)
	if player_input_manager.is_action_just_pressed(Model.Action.TOGGLE_CURSOR):
		finished.emit(Model.InputState.CURSOR)


func handle_character_moved(_character: Character, _old_coord: Vector2i, _new_coord: Vector2i) -> void:
	if prev_state != "" and _character.movement <= 0:
		finished.emit(prev_state)
