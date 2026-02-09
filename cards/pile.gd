class_name Pile
extends Control


#region Signals
signal shuffled()
signal card_added(card: Card)
signal card_removed(card: Card)
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
	is_faceup = !is_faceup
	pass
	

func add_card(_card: Card) -> void:
	push_warning("Function not implemented")
	pass


func remove_card(_card: Card) -> void:
	push_warning("Function not implemented")
	pass
#endregion
