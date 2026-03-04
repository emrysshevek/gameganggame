class_name CardManager
extends Control

#region Properties
@export var deck: Deck
@export var draw_pile: Pile
@export var discard_pile: Pile
@export var hand_pile: Pile
@export var character: Character

var input_man:PlayerInputManager

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

@export var input_state_machine: PlayerInputStateMachine
@export var input_manager: PlayerInputManager
@onready var card_scene := preload("res://cards/card.tscn")
#endregion


#region Built-ins
func _ready() -> void:
	if deck != null:
		set_deck(deck)
		turn_start_draw()
	input_state_machine.state_switched.connect(_on_state_machine_switched)

		
func _process(_delta: float) -> void:
	if input_state_machine.current_state == PlayerInputStateMachine.States.CARD:
		_handle_input()
#endregion


#region Public Methods
func set_deck(_deck: Deck) -> void:
	deck = _deck
	deck.card_added.connect(_on_deck_card_added)
	deck.card_removed.connect(_on_deck_card_removed)
	for card in deck.cards:
		card.clicked.connect(func(): _on_card_clicked(card))
		draw_pile.add_card(card)
	draw_pile.shuffle()
	
func draw(_count:=1) -> void:			
	if draw_pile.count < _count:
		refill_draw()
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


#region Private Methods
func _handle_input():
	# TODO: REMOVE!!!
	if input_man.is_action_just_released("move_up"):
		var card: Card = card_scene.instantiate()
		deck.add_card(card)
	if deck.count > 0 and input_man.is_action_just_released("move_down"):
		var card: Card = deck.cards[0]
		deck.remove_card(card)
		card.queue_free.call_deferred()
	if hand_pile.count > 0:
		if input_man.is_action_just_released("move_left"):
			_selected_card_index -= 1
		elif input_man.is_action_just_released("move_right"):
			_selected_card_index += 1
		elif input_man.is_action_just_released(Model.Action.SELECT):
			hand_pile.ordered_cards[_selected_card_index].play()
			hand_pile.ordered_cards[_selected_card_index].highlight_return()
			discard(hand_pile.ordered_cards[_selected_card_index])
			_selected_card_index -= 1
		elif input_man.is_action_just_released(Model.Action.DISCARD):
			hand_pile.ordered_cards[_selected_card_index].discard()
			hand_pile.ordered_cards[_selected_card_index].highlight_return()
			discard(hand_pile.ordered_cards[_selected_card_index])
			_selected_card_index -= 1

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
		
func _on_state_machine_switched(old_state:PlayerInputStateMachine.States, new_state:PlayerInputStateMachine.States):
	if new_state == PlayerInputStateMachine.States.CARD or old_state == PlayerInputStateMachine.States.CARD:
		_toggle_visibility()
		_selected_card_index = 2
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
	
func set_input_man(input_manager:PlayerInputManager) -> void:
	input_man = input_manager
	

func _card_selection_visuals(new_selected_card_index:int):
	var selected_card = hand_pile.ordered_cards[new_selected_card_index]
	for each_card in hand_pile.ordered_cards:
		if each_card == selected_card:
			each_card.highlight_react()
		else:
			each_card.highlight_return()
			
func _toggle_visibility():
	$Layout/HBoxContainer.visible = !$Layout/HBoxContainer.visible
	$Layout/TestLabel.visible = !$Layout/TestLabel.visible
#endregion
	
