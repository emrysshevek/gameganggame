extends Card

func _trigger_play_ability() -> void:
	var ally := targets[0] as Character
	var grid_man := Utils.try_get_grid_man()
	grid_man.move_object(owning_character, ally.grid_coordinates, 0)
	super._trigger_play_ability()
