extends Card

## Sprint: Gain 3 movement

func _trigger_play_ability() -> void:
	super._trigger_play_ability()
	owning_character.movement += 3
