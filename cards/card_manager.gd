class_name CardManager
extends Control


#region Properties
@export var deck: Deck
@export var draw_pile: Pile
@export var discard_pile: Pile
@export var hand_pile: Pile
@export var player: Player

@onready var card_scene := preload("res://cards/card.tscn")
#endregion


#region Built-ins
func _ready() -> void:
	if deck != null:
		set_deck(deck)
		
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("debug_up"):
		var card: Card = card_scene.instantiate()
		deck.add_card(card)
	if Input.is_action_just_pressed("debug_v"):
		deck.toggle_display()
	if deck.count > 0 and Input.is_action_just_pressed("debug_down"):
		var card: Card = deck.cards[0]
		deck.remove_card(card)
		card.queue_free.call_deferred()
#endregion


#region Public Methods
func set_deck(_deck: Deck) -> void:
	deck = _deck
	deck.card_added.connect(_on_deck_card_added)
	deck.card_removed.connect(_on_deck_card_removed)
	for card in deck.cards:
		card.clicked.connect(func(): _on_card_clicked(card))
	
func draw(_count:=1) -> void:			
	for i in _count:
		var card := draw_pile.get_top_card()
		hand_pile.add_card(card)
	
	
func discard(_card: Card) -> void:
	_card.pile.remove_card(_card)
	discard_pile.add_card(_card)
	
	
func refill_draw() -> void:
	discard_pile.shuffle()
	for i in discard_pile.count:
		draw_pile.add_card(discard_pile.get_top_card())
	
	
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
	_card.clicked.connect(func():_on_card_clicked(_card))
	draw_pile.add_card(_card, 0, true) # add and shuffle
	
	
func _on_deck_card_removed(_card) -> void:
	_card.pile.remove_card(_card)
	
	
func _on_card_clicked(_card) -> void:
	if _card.pile == hand_pile:
		discard(_card)
	elif _card.pile == draw_pile:
		draw()
	elif _card.pile == discard_pile:
		pass


func _on_draw_button_pressed() -> void:
	if draw_pile.count == 0:
		refill_draw()
#endregion
	
	
	
