extends Card

## pick and discard 1 card then draw 3 cards

func _trigger_play_ability() -> void:
	for each_card in targets:
		owning_character.my_screen.card_manager.discard(each_card)
	owning_character.my_screen.card_manager.draw(3)
	super._trigger_play_ability()
