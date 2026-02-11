class_name CardManager
extends Control


#region Properties
@export var deck: Deck
@export var draw_pile: Pile
@export var discard_pile: Pile
@export var hand_pile: Pile
@export var player: Player

@export var draw_marker: Control
@export var hand_marker: Control
@export var discard_marker: Control
#endregion


#region Built-ins
func _ready() -> void:
	draw_pile.area = Rect2(draw_marker.global_position, draw_marker.size)
	hand_pile.area = Rect2(hand_marker.global_position, hand_marker.size)
	discard_pile.area = Rect2(discard_marker.global_position, discard_marker.size)

	draw_pile.emptied.connect(_on_draw_pile_emptied)
	deck.card_added.connect(_on_deck_card_added)
	for card in deck.cards:
		card.request_discard.connect(_on_card_requested_discard)
#endregion


#region Public Methods
func draw(_count:=0) -> void:
	for i in _count:
		var card := draw_pile.get_top_card()
		hand_pile.add_card(card)
	
	
func discard(_card: Card) -> void:
	_card.pile.remove_card(_card)
	discard_pile.add_card(_card)
	
	
func return_discard() -> void:
	discard_pile.shuffle()
	for i in discard_pile.count:
		var card := discard_pile.get_top_card()
		draw_pile.add_card(card)
	
	
func shuffle_draw() -> void:
	draw_pile.shuffle()
#endregion
	

#region Signal Connections
func _on_draw_pile_emptied() -> void:
	return_discard()
	
	
func _on_deck_card_added(_card) -> void:
	draw_pile.add_card(_card, 0, true) # add and shuffle
	
	
func _on_deck_card_removed(_card) -> void:
	_card.pile.remove_card(_card)
	
	
func _on_card_requested_discard(_card) -> void:
	if _card.pile == hand_pile:
		discard(_card)
	if _card.pile == draw_pile:
		draw()
#endregion
	
	
