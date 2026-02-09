class_name Card
extends Node2D


#region Signals
signal card_played(which_card)
signal card_discarded(which_card)
#endregion


#region Properties
@export var cost: Dictionary
@export var description: String = ""
@export var deck: Deck = null
#endregion


func play() -> void:
	push_warning("function not implemented")
	pass
	
func discard() -> void:
	push_warning("function not implemented")
	pass
