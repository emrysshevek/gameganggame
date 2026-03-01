class_name PlayerInputState
extends State

const MOVE := "Move"
const CARD := "Card"
const CURSOR := "Cursor"

@export var player_input_manager: PlayerInputManager

var state: PlayerInputStateMachine.States


func handle_card_played(_card: Card) -> void:
	pass


func handle_character_sprite_moved(_character_sprite: CharacterSprite) -> void:
	pass
