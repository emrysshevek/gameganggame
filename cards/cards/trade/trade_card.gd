extends Card

##discard your hand, then draw that many cards + 1

func _trigger_play_ability() -> void:
	var hand_size:int = owning_character.my_screen.card_manager.hand_pile.count
	owning_character.my_screen.card_manager.discard_hand()
	owning_character.my_screen.card_manager.draw(hand_size + 1)
	super._trigger_play_ability()
