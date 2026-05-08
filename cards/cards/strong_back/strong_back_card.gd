extends Card

##discard all resource cards in hand and draw that many cards + 1

func _trigger_play_ability() -> void:
	var count:int = 0
	var cards_in_hand:Array[Card] = owning_character.my_screen.card_manager.hand_pile.cards
	for each_card in cards_in_hand:
		if each_card is LootCard:
			count += 1
			owning_character.my_screen.card_manager.discard(each_card)
	owning_character.my_screen.card_manager.draw(count + 1)
	super._trigger_play_ability()
