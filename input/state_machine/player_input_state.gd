class_name PlayerInputState
extends State

const MOVE := "move"
const CARD := "card"
const CURSOR := "cursor"

@export var character_sprite: CharacterSprite
@export var player_input_manager: PlayerInputManager

var state: PlayerInputStateMachine.States


func handle_card_played(_card: Card) -> void:
	pass


func handle_character_sprite_moved(_character_sprite: CharacterSprite) -> void:
	pass
