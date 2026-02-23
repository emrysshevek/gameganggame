class_name CardManager
extends Control

#region Properties
@export var deck: Deck
@export var draw_pile: Pile
@export var discard_pile: Pile
@export var hand_pile: Pile
@export var player: Player

@onready var _selected_card_index:int = 2:
	get():
		return _selected_card_index
	set(new_value):
		if hand_pile.count == 0:
			new_value = -1
		elif new_value < 0:
			new_value = hand_pile.count - 1
		elif new_value > hand_pile.count - 1:
			new_value = 0
		_selected_card_index = new_value
		if new_value != -1:
			_card_selection_visuals(_selected_card_index)

@onready var card_scene := preload("res://cards/card.tscn")
@onready var fake_state_machine:String = "character"
#endregion


#region Built-ins
func _ready() -> void:
	deck.card_added.connect(_on_deck_card_added)
	deck.card_removed.connect(_on_deck_card_removed)
	for card in deck.cards:
		card.clicked.connect(func(): _on_card_clicked(card))
		
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("debug_up") && fake_state_machine == "cards":
		var card: Card = card_scene.instantiate()
		deck.add_card(card)
	if Input.is_action_just_pressed("debug_v"):
		#deck.toggle_display()
		_toggle_visibility()
	if deck.count > 0 and Input.is_action_just_pressed("debug_down") && fake_state_machine == "cards":
		var card: Card = deck.cards[0]
		deck.remove_card(card)
		card.queue_free.call_deferred()
	_card_selection_input(_event)
#endregion


#region Public Methods
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
	
#region Testing methods
func setup_testing_cards():
	var testing_cards:Array
	for i in 5:
		var card: Card = card_scene.instantiate()
		testing_cards.append(card)
	return testing_cards

func turn_start_draw():
	draw(5)
	
func _card_selection_input(_event: InputEvent) -> void:
	if hand_pile.count > 0 && fake_state_machine == "cards":
		if Input.is_action_just_pressed("move_left"):
			_selected_card_index -= 1
		elif Input.is_action_just_pressed("move_right"):
			_selected_card_index += 1
		elif Input.is_action_just_pressed("debug_f"):
			#check for values
			hand_pile.ordered_cards[_selected_card_index].play()
			hand_pile.ordered_cards[_selected_card_index].highlight_return()
			discard(hand_pile.ordered_cards[_selected_card_index])
			_toggle_visibility()
			
func _card_selection_visuals(new_selected_card_index:int):
	var selected_card = hand_pile.ordered_cards[new_selected_card_index]
	for each_card in hand_pile.ordered_cards:
		if each_card == selected_card:
			each_card.highlight_react()
		else:
			each_card.highlight_return()
			
func _toggle_visibility():
	if fake_state_machine != "cards":
		fake_state_machine = "cards"
	else:
		fake_state_machine = "character"
	$Layout/HBoxContainer.visible = !$Layout/HBoxContainer.visible
	$Layout/TestLabel.visible = !$Layout/TestLabel.visible
#endregion
	
