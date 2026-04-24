extends Card

## Examine: Reveal a tile in range 3

func _trigger_play_ability() -> void:
	(targets[0] as Tile).reveal(owning_character)
	super._trigger_play_ability()
