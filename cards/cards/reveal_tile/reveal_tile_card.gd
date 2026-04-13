extends Card

func _trigger_play_ability() -> void:
	(targets[0] as Tile).reveal(owning_character)
	super._trigger_play_ability()
