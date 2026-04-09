extends Card

func validate_target(potential_target: Node) -> bool:
	if potential_target == self:
		return false
		
	return super.validate_target(potential_target)
	
	
func _trigger_play_ability() -> void:
	var player_character: Character = targets[0] as Character
	player_character.movement += 3
	super._trigger_play_ability()
