class_name CardManager
extends Control


#region Properties
@export var deck: Deck
@export var draw_pile: Pile
@export var discard_pile: Pile
@export var hand_pile: Pile
@export var player: Player
#endregion


#region Built-ins
func _ready() -> void:
	deck.card_added.connect(_on_deck_card_added)
	for card in deck.cards:
		card.request_discard.connect(func():_on_card_requested_discard(card))
#endregion


#region Public Methods
func draw(_count:=1) -> void:			
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
func _on_deck_card_added(_card) -> void:
	_card.request_discard.connect(func():_on_card_requested_discard(_card))
	draw_pile.add_card(_card, 0, true) # add and shuffle
	
	
func _on_deck_card_removed(_card) -> void:
	_card.pile.remove_card(_card)
	
	
func _on_card_requested_discard(_card) -> void:
	if _card.pile == hand_pile:
		discard(_card)
	if _card.pile == draw_pile:
		draw()


#func _on_refill_draw_button_pressed() -> void:
	#if draw_pile.count == 0:
		#discard_pile.shuffle()
		#for i in discard_pile.count:
			#draw_pile.add_card(discard_pile.get_top_card())
#endregion
	
	
