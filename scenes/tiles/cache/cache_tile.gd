class_name CacheTile
extends Tile


## caches ALL resource cards from deck when player enters tile
## when enough resources have been cached, win the game

@export var required_cards_per_player := 1
var total_count := 0

@onready var label: Label = $Front/Label


func _ready() -> void:
	super._ready()
	_update_label()


func enter(entering_character:Character):
	super.enter(entering_character)
	
	var cards: Array[Card] = []
	var cm := entering_character.my_screen.card_manager
	
	# cache resource cards in all piles
	cards.append_array(cm.hand_pile.cards.filter(func(x): return x is LootCard))
	cards.append_array(cm.draw_pile.cards.filter(func(x): return x is LootCard))
	cards.append_array(cm.discard_pile.cards.filter(func(x): return x is LootCard))
	var count := cards.size()

	for card: Card in cards:
		cm.remove_card(card)

	Events.resources_cached.emit(count)
	
	total_count += count
	if total_count >= required_cards_per_player * Config.player_count:
		Events.game_won.emit()
	
	_update_label()


func add_hazard(_new_hazard:Hazard) -> bool:
	return false
	
	
func _update_label() -> void:
	label.text = str(total_count) + "/" + str(required_cards_per_player * Config.player_count)
