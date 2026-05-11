extends Card

## draw 2 cards

func _trigger_play_ability() -> void:
	owning_character.my_screen.card_manager.draw(2)
	super._trigger_play_ability()
