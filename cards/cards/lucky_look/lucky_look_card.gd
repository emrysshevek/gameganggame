extends Card

## Lucky Look: Gain move 2 and Lucky Look 2

func _trigger_play_ability() -> void:
	owning_character.movement += 2
	owning_character.status_manager.add_status(LuckyLookStatus.new(2))
	super._trigger_play_ability()
