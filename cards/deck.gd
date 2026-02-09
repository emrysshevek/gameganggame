class_name Deck
extends Node2D


#region Signals
signal card_added_to_deck(which_card: Card, which_deck: Deck)
signal card_removed_from_deck(which_card: Card, which_deck: Deck)
#endregion


#region Properties
@export var cards: Array[Card]
var count: int:
	get:
		return len(cards)
var player = null
#endregion


#region Methods
func add_card(which_card: Card) -> void:
	push_warning("function not implented")
	pass
	
func remove_card(which_card: Card) -> void:
	push_warning("function not implemented")
	pass
#endregion
