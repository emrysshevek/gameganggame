class_name PlayerInputState
extends State


@export var player_input_manager: PlayerInputManager

var state: String
var character: Character


func physics_update(_delta: float) -> void:
	super.physics_update(_delta)
	if player_input_manager.is_action_just_pressed(Model.Action.TOGGLE_END_TURN):
		finished.emit(Model.InputState.END)


func handle_round_started() -> void:
	pass


func handle_card_played(_card: Card) -> void:
	pass
	
	
func handle_card_discarded(_card: Card) -> void:
	pass


func handle_character_moved(_character: Character, _old_coord: Vector2i, _new_coord: Vector2i) -> void:
	pass
