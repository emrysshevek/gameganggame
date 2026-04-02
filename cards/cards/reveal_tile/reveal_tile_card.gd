extends Card

func _trigger_play_ability() -> void:
	targets[0].reveal(owning_character.character_id)
	super._trigger_play_ability()
