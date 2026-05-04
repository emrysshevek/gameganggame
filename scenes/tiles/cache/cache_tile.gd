class_name CacheTile
extends Tile


## caches ALL resource cards from deck when player enters tile
## must be connected to all starting tiles
## cannot have a hazard or resource card at start of round
## when enough resources have been cached, win the game


func enter(entering_character:Character):
	super.enter(entering_character)
	
	var cards: Array[Card] = []
	var cm := entering_character.my_screen.card_manager
	
	cards.append_array(cm.hand_pile.cards.filter(func(x): return x is LootCard))
	cards.append_array(cm.draw_pile.cards.filter(func(x): return x is LootCard))
	cards.append_array(cm.discard_pile.cards.filter(func(x): return x is LootCard))
	var count := cards.size()
	
	for card: Card in cards:
		cm.remove_card(card)
		
	Events.resources_cached.emit(count)
