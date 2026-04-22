extends Card

##discard all resource cards in hand and draw that many cards + 1

func _trigger_play_ability() -> void:
	var resource_cards:Array[Card]
	var cards_in_hand:Array[Card] = owning_character.my_screen.card_manager.hand_pile.cards
	for each_card in cards_in_hand:
		if each_card is LootCard:
			resource_cards.append(each_card)
	var cards_to_draw:int = resource_cards.size() + 1
	for each_card in resource_cards:
		owning_character.my_screen.card_manager.discard(each_card)
	owning_character.my_screen.card_manager.draw(cards_to_draw)
	super._trigger_play_ability()
