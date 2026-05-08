extends Card

##if this card is discarded draw one card

func _trigger_play_ability() -> void:
	fail_to_play()

func _trigger_discard_ability() -> void:
	owning_character.my_screen.card_manager.draw(1)
