class_name PlayerInputStateMachine
extends StateMachine

signal state_switched(old_state, new_state)

@export var character: Character
var current_state: String:
	get:
		return (state as PlayerInputState).state
		
var input_manager: PlayerInputManager

func _ready() -> void:
	super._ready()
	if character != null:
		set_character(character)
	
	Events.round_started.connect(_on_round_started)
	Events.card_played.connect(_on_card_played)
	Events.card_discarded.connect(_on_card_discarded)


func set_character(_character: Character) -> void:
	character = _character
	##temporarily turning this off until it can be hooked back up to Character obj
	character.moved.connect(_on_character_moved)
	for player_input_state_node: PlayerInputState in find_children("*", "State"):
		player_input_state_node.player_input_manager = character.input_man
		player_input_state_node.character = _character


func _on_round_started() -> void:
	(state as PlayerInputState).handle_round_started()


func _on_card_played(_card: Card) -> void:
	if _card.owning_character == character:
		(state as PlayerInputState).handle_card_played(_card)
		
		
func _on_card_discarded(_card: Card) -> void:
	if _card.owning_character == character:
		(state as PlayerInputState).handle_card_discarded(_card)


func _on_character_moved(_character: Character, _old_coord: Vector2i, _new_coord: Vector2i) -> void:
	(state as PlayerInputState).handle_character_moved(_character, _old_coord, _new_coord)
	

func _transition_to_next_state(target_state_path: String, data: Dictionary = {}) -> void:
	var old_state = current_state
	super._transition_to_next_state(target_state_path, data)
	var new_state = current_state
	state_switched.emit(old_state, new_state)
