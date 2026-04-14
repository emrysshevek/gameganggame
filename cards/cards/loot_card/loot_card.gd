class_name LootCard extends Card

## Resource: Unplayable. Dropped onto tile when discarded

func _trigger_play_ability() -> void:
	fail_to_play()
	
func _trigger_discard_ability() -> void:
	owning_character.movement += 1
	owning_character.queued_drop_cards.append(self)
