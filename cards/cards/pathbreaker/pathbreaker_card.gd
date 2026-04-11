extends Card


func _trigger_play_ability() -> void:
	owning_character.movement += 1
	owning_character.status_manager.add_status(PathbreakerStatus.new(1))
	super._trigger_play_ability()
