extends Card

## Heal the character within range 3 with te least hp by 3

@export var effect_range := 3
@export var heal_amount := 3

func _trigger_play_ability() -> void:
	var grid_man := Utils.try_get_grid_man()
	var coords := owning_character.grid_coordinates
	var boundaries = Vector2i(grid_man.map_width, grid_man.map_height)
	
	# keep track of the character with lowest health. Default to self so that
	# there is something to compare to (if this is undesired, can change later)
	var target: Character = owning_character 
	
	# iterate over tiles with a radius of `effect_range` (respecting the borders of the grid)
	for i in range(max(coords.x - effect_range, 0), min(coords.x + effect_range, boundaries.x)):
		for j in range(max(coords.y - effect_range, 0), min(coords.y + effect_range, boundaries.y)):
			var target_coords := Vector2i(i, j)
			
			# ignore tiles that are not actually in range
			if grid_man.get_crow_flies_distance(coords, target_coords) <= effect_range:
				# check any characters' health on the tile against the current target
				var characters = grid_man.get_tile(target_coords).get_contents([Model.ObjectTypes.PLAYER_CHARACTER])
				for character: Character in characters:
					if character.health_current < target.health_current:
						target = character
	
	# will always have at least self to heal
	target.heal(heal_amount)

	super._trigger_play_ability()
