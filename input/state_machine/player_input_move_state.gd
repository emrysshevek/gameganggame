class_name PlayerInputMoveState
extends PlayerInputState


var prev_state: String


func enter(_previous_state_path: String, _data := {}) -> void:
	prev_state = _previous_state_path


func update(_delta: float) -> void:
	if player_input_manager.is_action_just_pressed(Model.Action.TOGGLE_MAP):
		finished.emit(prev_state)


func handle_character_sprite_moved(_character_sprite: CharacterSprite) -> void:
	# TODO: check if character has 0 movement left and transition to previous state
	pass
