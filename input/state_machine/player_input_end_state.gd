class_name PlayerInputEndState
extends PlayerInputState


func enter(_previous_state_path: String, _data := {}) -> void:
	Events.player_turn_ended.emit(character)


func handle_turn_started() -> void:
	finished.emit(Model.InputState.CURSOR)
