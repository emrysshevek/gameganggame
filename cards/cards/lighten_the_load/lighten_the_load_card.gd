extends Card

## take all resource cards from target player within range 3

func _trigger_play_ability() -> void:
	if targets.is_empty() == false:
		var target:Character = targets[0] as Character
		var targets_cards:Array[Card]
		targets_cards.append_array(target.my_screen.card_manager.hand_pile.cards)
		targets_cards.append_array(target.my_screen.card_manager.discard_pile.cards)
		targets_cards.append_array(target.my_screen.card_manager.draw_pile.cards)
		var resource_cards:Array[Card]
		for each_card in targets_cards:
				if each_card is LootCard:
					resource_cards.append(each_card)
		for each_card in resource_cards:
			target.my_screen.card_manager.remove_card(each_card)
			owning_character.my_screen.card_manager.hand_pile.add_card(each_card)
	else:
		owning_character.play_error_pop_up("must target a player character")
	#so that you don't get stuck in targetting mode if you target a tile without a player character the card
	#just discards and has no direct effect
	super._trigger_play_ability()
