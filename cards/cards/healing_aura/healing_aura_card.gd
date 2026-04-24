extends Card

## Healing Aura: all characters within range 3 heal 3

@export var target_range := 3
@export var heal_amount := 3

func _trigger_play_ability() -> void:
	var grid_man := Utils.try_get_grid_man()
	for character: Character in Utils.try_get_game_scene().characters:
		var dist = grid_man.get_distance(0, owning_character.grid_coordinates, character.grid_coordinates)
		if dist <= target_range:
			character.heal(heal_amount)
	
	super._trigger_play_ability()
