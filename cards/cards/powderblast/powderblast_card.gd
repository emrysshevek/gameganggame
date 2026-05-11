extends Card

## Turn an adjacent unoccupied room into an empty 4-path tile with no effects or hazards.

func _trigger_play_ability() -> void:
	var target = targets[0] as Tile
	if target.characters.is_empty() == true:
		var grid_man := Utils.try_get_grid_man()
		var valid_neighbors:Array[Tile]
		var offset_array:Array[Vector2] = [Vector2(1, 0), Vector2(0,1), Vector2(-1,0), Vector2(0,-1)]
		for i in offset_array:
			if grid_man.is_in_bounds(target.grid_coordinates + i):
				grid_man.add_path(target, grid_man.get_tile(target.grid_coordinates + i))
		target.remove_hazard()
		target.reveal(owning_character)
	else:
		owning_character.play_error_pop_up("tile is occupied")
	super._trigger_play_ability()
