class_name LootCard extends Card

func _trigger_play_ability() -> void:
	print("loot card cannot be played")
	pass
	
func _trigger_discard_ability() -> void:
	owning_character.movement += 1
	owning_character.queued_drop_cards.append(self)
