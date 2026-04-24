extends Card

## Strong Back: discard all resource cards in hand and draw that many cards +1


func _trigger_play_ability() -> void:
	var card_manager := owning_character.my_screen.card_manager
	var count = 0
	for card: Card in card_manager.hand_pile.cards:
		if card is LootCard:
			card_manager.discard(card)
			count += 1
	card_manager.draw(count)
	super._trigger_play_ability()
