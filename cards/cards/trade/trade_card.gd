extends Card

##discard your hand, then draw that many cards + 1

func _trigger_play_ability() -> void:
	var hand_size:int = owning_character.my_screen.card_manager.hand_pile.count
	var owning_characters_cards:Array[Card] = owning_character.my_screen.card_manager.hand_pile.cards.duplicate(true)
	for each_card in owning_characters_cards:
		if each_card != self:
			owning_character.my_screen.card_manager.discard(each_card)
	#discarding each card other than the card you are currently playing, as it will discard after resolving
	#but if discarded before resolving causes an error on discard attempt
	owning_character.my_screen.card_manager.draw(hand_size + 1)
	super._trigger_play_ability()
