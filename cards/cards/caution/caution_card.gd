extends Card

## Protect one character from the negative effects of the next tile hazard


func _trigger_play_ability() -> void:
	var ally := targets[0] as Character
	ally.status_manager.add_status(ProtectedStatus.new(1))
	super._trigger_play_ability()
