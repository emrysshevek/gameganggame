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

@export var draw_pile: Pile
@export var discard_pile: Pile
@export var hand_pile: Pile

@export var player = null
#endregion


#region Methods
func add_card(_card: Card) -> void:
	assert(_card not in cards)
	_card.request_discard.connect(_on_card_requested_discard)
	cards.append(_card)
	card_added.emit(_card)
	

func remove_card(_card: Card) -> void:
	assert(_card in cards)
	cards.erase(_card)
	card_removed.emit(_card)
#endregion


func _on_card_requested_discard(_card: Card) -> void:
	pass
