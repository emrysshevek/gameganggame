class_name LootCard extends Card

func _ready() -> void:
	targets_required[Model.ObjectTypes.PLAYER_CHARACTER] = 1
	target_range_max = 0

func _trigger_play_ability() -> void:
	print("loot card cannot be played")
	pass
	
func _trigger_discard_ability() -> void:
	owning_character.movement += 1
	#then remove from deck and drop on tile
