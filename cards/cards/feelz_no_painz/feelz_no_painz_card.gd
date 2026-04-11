extends Card


func _trigger_play_ability() -> void:
	owning_character.status_manager.add_status(FeelNoPainStatus.new(1))
	super._trigger_play_ability()
