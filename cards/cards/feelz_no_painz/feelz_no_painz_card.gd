extends Card

## Feelz No Painz: Gain 1 Feelz No Painz (For 1 round, gain B every time you take damage)


func _trigger_play_ability() -> void:
	owning_character.status_manager.add_status(FeelNoPainStatus.new(1))
	super._trigger_play_ability()
