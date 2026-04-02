extends Card

func _trigger_play_ability() -> void:
	owning_character.movement += 3
	super._trigger_play_ability()
	
