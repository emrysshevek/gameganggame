extends Card

##cycle all elements by 1

func _trigger_play_ability() -> void:
	var value_manager:ValueManager = Utils.try_get_value_manager()
	var cycling_values:Dictionary[Model.CreatureValue, int]
	for each_value_type in Model.CreatureValue:
		var current_value_int = value_manager.get_value(Model.CreatureValue[each_value_type])
		value_manager.reserve_value(Model.CreatureValue[each_value_type], value_manager.get_value(Model.CreatureValue[each_value_type]))
		cycling_values[Model.CreatureValue[each_value_type]] = current_value_int
	for each_value_type in Model.CreatureValue:
		if cycling_values[Model.CreatureValue[each_value_type]] > 0:
			value_manager.use_reserved_value(Model.CreatureValue[each_value_type], cycling_values[Model.CreatureValue[each_value_type]])
	super._trigger_play_ability()
