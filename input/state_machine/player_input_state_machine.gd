class_name PlayerInputStateMachine
extends StateMachine


@export var character_sprite: CharacterSprite

func _ready() -> void:
	if character_sprite != null:
		set_character_sprite(character_sprite)
	
	Events.card_played.connect(_on_card_played)
		

func set_character_sprite(_character_sprite: CharacterSprite) -> void:
	character_sprite = _character_sprite
	character_sprite.moved.connect(_on_character_sprite_moved)
	for player_input_state_node: PlayerInputState in find_children("*", "State"):
		player_input_state_node.player_input_manager = _character_sprite.input_man


func _on_card_played(_card: Card) -> void:
	(state as PlayerInputState).handle_card_played(_card)


func _on_character_sprite_moved() -> void:
	(state as PlayerInputState).handle_character_sprite_moved(character_sprite)
