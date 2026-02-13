class_name Pile
extends Control


#region Signals
signal shuffled()
signal card_added(card: Card)
signal card_removed(card: Card)
signal emptied()
#endregion


#region Properties
@export var cards: Array[Card] = []
var count: int:
	get:
		return cards.size()
@export var is_faceup: bool = true

@onready var ordered_cards: Array[Card] = cards.duplicate()
#endregion


#region Godot Built-in Methods
func _ready() -> void:
	_reposition()
#endregion


#region Methods
func get_top_card() -> Card:
	var card = cards[0]
	remove_card(cards[0])
	return card
	

func get_bottom_card() -> Card:
	var card = cards[-1]
	remove_card(card)
	return card

	
func shuffle() -> void:
	ordered_cards.shuffle()
	shuffled.emit()

	
func flip() -> void:
	is_faceup = !is_faceup
	for card in cards:
		if card.is_faceup != is_faceup:
			card.flip()
	

func add_card(_card: Card, _position:int=-1, _shuffle=false) -> void:
	# cards are added to bottom of pile by default
	# to insert to a specific index, set value of position
	assert(_card not in cards)
	if count == 0:
		_position = 0
	cards.append(_card)
	ordered_cards.insert(_position, _card)
	
	if _card.get_parent() == null:
		add_child(_card)
	else:
		_card.reparent(self)
	_card.pile = self
	
	if _shuffle:
		shuffle()
	
	if _card.is_faceup != is_faceup:
		_card.flip()
	_reposition()
	
	card_added.emit(_card)


func remove_card(_card: Card) -> void:
	print(_card.name)
	assert(_card in cards)
	cards.erase(_card)
	ordered_cards.erase(_card)
	_reposition()
	_card.pile = null
	card_removed.emit()
	if count == 0:
		emptied.emit()
	

func move(_global_position: Vector2, _size: Vector2) -> void:
	global_position = _global_position
	size = _size
	_reposition()
#endregion


func _reposition() -> void:
	if count == 0:
		return
		
	var is_horizontal := size.x >= size.y
	var spacing := Vector2(size.x / float(count + 1), 0)
	var area_offset := Vector2(0, size.y / 2.0)
	var card_offset := cards[0].size / 2.0
	
	if not is_horizontal:
		area_offset = Vector2(size.x / 2.0, 0)
		spacing = Vector2(0, size.y / float(count + 1))
	if size == Vector2.ZERO:
		spacing.y -= 2
	
	var curr_pos := global_position + area_offset - card_offset
	for i in len(ordered_cards):
		var card := ordered_cards[i]
		curr_pos += spacing
		card._description_label.text = str(i)
		card.global_position = curr_pos
		card.z_index = i
