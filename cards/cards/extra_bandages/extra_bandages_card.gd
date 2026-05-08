extends Card

#when discarded heal 1 if E value is > 0

func _trigger_play_ability() -> void:
	fail_to_play()

func _trigger_discard_ability() -> void:
	if Utils.try_get_value_manager().get_value(Model.CreatureValue.EMPATHY) > 0:
		owning_character.heal(1)
