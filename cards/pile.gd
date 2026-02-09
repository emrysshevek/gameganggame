class_name Pile
extends Control


#region Signals
signal shuffled(which_pile: Pile)
signal card_added(which_pile: Pile, which_card: Card)
signal card_removed(which_pile: Pile, which_card: Card)
#endregion


#region Properties
@export var cards: Array[Card] = []
var count: int:
	get:
		return len(cards)
@export var deck: Deck = null
@export var is_faceup: bool = true
#endregion


#region Methods
func shuffle() -> void:
	push_warning("Function not implemented")
	pass

	
func flip() -> void:
	push_warning("Function not implemented")
	pass
	

func add_card(which_card: Card) -> void:
	push_warning("Function not implemented")
	pass


func remove_card(which_card: Card) -> void:
	push_warning("Function not implemented")
	pass
#endregion
