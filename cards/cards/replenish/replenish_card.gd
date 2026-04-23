extends Card

##Draw cards until there are 3 non-resource cards in your hand

func _trigger_play_ability() -> void:
	var cards_in_hand:Array[Card] = owning_character.my_screen.card_manager.hand_pile.cards
	var resource_cards:Array[Card]
	for each_card in cards_in_hand:
			if each_card is LootCard:
				resource_cards.append(each_card)
	while cards_in_hand.size() - resource_cards.size() < 4: #4 because this card always counts itself before discarding
		owning_character.my_screen.card_manager.draw(1)
		resource_cards.clear()
		cards_in_hand = owning_character.my_screen.card_manager.hand_pile.cards
		for each_card in cards_in_hand:
			if each_card is LootCard:
				resource_cards.append(each_card)
	super._trigger_play_ability()
