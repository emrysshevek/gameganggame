extends Card

## Cycle: cycle all elements by 1


func _trigger_play_ability() -> void:
	var value_manager := Utils.try_get_value_manager()
	var starting_vals := value_manager._creature_values.duplicate()
	for creature_val in starting_vals.keys():
		value_manager.use_value(creature_val, starting_vals[creature_val])
	super._trigger_play_ability()
