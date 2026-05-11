extends Card

## Teleport another character in range 5 to a random valid tile adjacent to the character playing this card

func _trigger_play_ability() -> void:
	if targets.is_empty() == false:
		var grid_man:GridManager = Utils.try_get_grid_man()
		var valid_tiles:Array[Tile]
		var offset_array:Array[Vector2] = [Vector2(1, 0), Vector2(0,1), Vector2(-1,0), Vector2(0,-1)]
		for i in offset_array:
			if grid_man.is_directly_connected(owning_character.current_floor, owning_character.grid_coordinates, owning_character.grid_coordinates + i):
				valid_tiles.append(grid_man.get_tile(owning_character.grid_coordinates + i))
		if valid_tiles.is_empty() == false:
			#if there are somehow no valid tiles in range 1 of the character using this card it just does nothing
			var target:Character = targets[0] as Character
			var tile = valid_tiles.pick_random()
			#"teleports" the object to the new tile
			grid_man.move_object(target, Vector2(tile.grid_coordinates.x, tile.grid_coordinates.y), target.current_floor, true)
	else:
		owning_character.play_error_pop_up("must target a player character")
	#so that you don't get stuck in targetting mode if you target a tile without a player character the card
	#just discards and has no direct effect
	super._trigger_play_ability()
