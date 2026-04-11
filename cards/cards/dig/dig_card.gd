extends Card


func _trigger_play_ability() -> void:
	var grid_man := Utils.try_get_grid_man()
	var curr_tile := grid_man.get_tile(owning_character.grid_coordinates)
	var neighbor_tile := targets[0] as Tile
	grid_man.add_path(curr_tile, neighbor_tile)
	super._trigger_play_ability()
