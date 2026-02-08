class_name Card
extends Node2D


#region Signals
signal card_played(which_card)
signal card_discarded(which_card)
#endregion


#region Properties
@export var cost: int
@export var description: String
var deck
#endregion


func play() -> void:
	push_warning("Card.play function not implemented")
	pass
	
func discard() -> void:
	push_warning("Card.discard function not implemented")
	pass
