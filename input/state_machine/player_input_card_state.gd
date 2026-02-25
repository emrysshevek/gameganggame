class_name PlayerInputCardState
extends PlayerInputState


func _ready() -> void:
	state = PlayerInputStateMachine.States.CARD
	
	
func update(_delta: float) -> void:
	if player_input_manager.is_action_just_pressed(Model.Action.TOGGLE_MAP):
		finished.emit(MOVE)


func handle_card_played(_card: Card) -> void:
	# TODO:
	# if card gives movement, transition to move state
	# if card targets board entity (character, tile, etc), transition to cursor state
	finished.emit(MOVE)
