class_name PlayerInputStateMachine
extends StateMachine

signal state_switched(old_state, new_state)

@export var character: Character
var current_state: String:
	get:
		return (state as PlayerInputState).state

func _ready() -> void:
	super._ready()
	if character != null:
		set_character(character)
	
	Events.card_played.connect(_on_card_played)
		

func set_character(_character: Character) -> void:
	character = _character
	##temporarily turning this off until it can be hooked back up to Character obj
	character.moved.connect(_on_character_sprite_moved)
	for player_input_state_node: PlayerInputState in find_children("*", "State"):
		player_input_state_node.player_input_manager = character.input_man


func _on_card_played(_card: Card) -> void:
	if _card.character_sprite == character:
		(state as PlayerInputState).handle_card_played(_card)


func _on_character_sprite_moved(_character: Character, _old_pos: Vector2i, _new_pos: Vector2i) -> void:
	(state as PlayerInputState).handle_character_sprite_moved(character)

func _transition_to_next_state(target_state_path: String, data: Dictionary = {}) -> void:
	var old_state = current_state
	super._transition_to_next_state(target_state_path, data)
	var new_state = current_state
	state_switched.emit(old_state, new_state)
