class_name PlayerInputCardState
extends PlayerInputState


func _ready() -> void:
	state = PlayerInputStateMachine.States.CARD


func handle_card_played(_card: Card) -> void:
	# TODO:
	# if card gives movement, transition to move state
	# if card targets board entity (character, tile, etc), transition to cursor state
	finished.emit(CURSOR)
