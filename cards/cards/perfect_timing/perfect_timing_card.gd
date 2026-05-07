extends Card

## search draw pile for card then add it to hand, then shuffle

func _trigger_play_ability() -> void:
	owning_character.my_screen.card_manager.draw_pile.remove_card(targets[0])
	owning_character.my_screen.card_manager.hand_pile.add_card(targets[0])
	super._trigger_play_ability()
