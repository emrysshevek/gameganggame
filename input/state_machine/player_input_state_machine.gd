class_name PlayerInputStateMachine
extends StateMachine

signal state_switched(old_state, new_state)

enum States {
	MOVE,
	CARD,
	CURSOR,
}


@export var character_sprite: CharacterSprite
var current_state: States:
	get:
		return (state as PlayerInputState).state

func _ready() -> void:
	super._ready()
	if character_sprite != null:
		set_character_sprite(character_sprite)
	
	Events.card_played.connect(_on_card_played)
		

func set_character_sprite(_character_sprite: CharacterSprite) -> void:
	character_sprite = _character_sprite
	##temporarily turning this off until it can be hooked back up to Character obj
	#character_sprite.moved.connect(_on_character_sprite_moved)
	for player_input_state_node: PlayerInputState in find_children("*", "State"):
		player_input_state_node.player_input_manager = _character_sprite.input_man


func _on_card_played(_card: Card) -> void:
	if _card.character_sprite == character_sprite:
		(state as PlayerInputState).handle_card_played(_card)


func _on_character_sprite_moved() -> void:
	(state as PlayerInputState).handle_character_sprite_moved(character_sprite)

func _transition_to_next_state(target_state_path: String, data: Dictionary = {}) -> void:
	var old_state = current_state
	super._transition_to_next_state(target_state_path, data)
	var new_state = current_state
	state_switched.emit(old_state, new_state)
