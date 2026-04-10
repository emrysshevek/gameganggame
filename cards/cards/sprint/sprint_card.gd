extends Card

func _trigger_play_ability() -> void:
	super._trigger_play_ability()
	owning_character.movement += 3
