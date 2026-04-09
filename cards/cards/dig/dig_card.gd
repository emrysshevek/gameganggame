extends Card

func _trigger_play_ability() -> void:
	var grid: GridManager = Utils.try_get_grid_man()
	var curr_tile: Tile = grid.get_tile(owning_character.grid_coordinates)
	var neighbor: Tile = targets[0]
	grid.add_path(curr_tile, neighbor)
