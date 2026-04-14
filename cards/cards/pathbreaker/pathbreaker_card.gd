extends Card

## Pathbreaker: Gain 1 move and Pathbreaker 1 (for next 1 move, gain a move when exploring a tile)


func _trigger_play_ability() -> void:
	owning_character.movement += 1
	owning_character.status_manager.add_status(PathbreakerStatus.new(1))
	super._trigger_play_ability()
