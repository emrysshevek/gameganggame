extends Card


func _trigger_play_ability() -> void:
	super._trigger_play_ability()
	owning_character.movement += 1
	owning_character.status_manager.add_status(PathbreakerStatus.new(1))
