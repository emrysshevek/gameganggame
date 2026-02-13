class_name Deck
extends Node2D


#region Signals
signal card_added(_card: Card)
signal card_removed(_card: Card)
#endregion


#region Properties
@export var cards: Array[Card]
var count: int:
	get:
		return len(cards)
@export var player: Player = null

@export var cards_node: Node2D
@export var deck_view: CanvasLayer
@export var vbox: VBoxContainer
#endregion


#region Methods
func add_card(_card: Card) -> void:
	assert(_card not in cards)
	cards.append(_card)
	if _card.get_parent() == null:
		cards_node.add_child(_card)
	else:
		_card.reparent(cards_node)
	card_added.emit(_card)
	

func remove_card(_card: Card) -> void:
	assert(_card in cards)
	card_removed.emit(_card)
	cards.erase(_card)
	

func toggle_display() -> void:
	if deck_view.visible:
		_hide_display()
	else:
		_show_display()
#endregion


#region Private Methods
func _show_display() -> void:
	var row: HBoxContainer
	for i in range(len(cards)):
		if i % 4 == 0:
			row = HBoxContainer.new()
			vbox.add_child(row)
		
		var card := cards[i].duplicate()
		if not card.is_faceup: card.flip()
		row.add_child(card)
	
	deck_view.show()
		
	

func _hide_display() -> void:
	for child in vbox.get_children():
		child.queue_free()
	deck_view.hide()
#endregion
