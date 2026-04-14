extends Card

## Sprint: Gain 3 movement

func _trigger_play_ability() -> void:
	owning_character.movement += 3
	super._trigger_play_ability()
