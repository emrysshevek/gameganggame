class_name Deck
extends Node2D


#region Signals
signal card_added(which_card: Card)
signal card_removed(which_card: Card)
#endregion


#region Properties
@export var cards: Array[Card]
var count: int:
	get:
		return len(cards)
@export var player = null
#endregion


#region Methods
func add_card(which_card: Card) -> void:
	push_warning("function not implented")
	pass
	

func remove_card(which_card: Card) -> void:
	push_warning("function not implemented")
	pass
#endregion
