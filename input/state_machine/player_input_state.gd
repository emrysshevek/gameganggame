class_name PlayerInputState
extends State


@export var player_input_manager: PlayerInputManager

var state: String


func handle_card_played(_card: Card) -> void:
	pass
	
	
func handle_card_discarded(_card: Card) -> void:
	pass


func handle_character_moved(_character: Character, _old_coord: Vector2i, _new_coord: Vector2i) -> void:
	pass
