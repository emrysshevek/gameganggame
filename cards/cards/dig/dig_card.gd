extends Card

func _trigger_play_ability() -> void:
	var grid: GridManager = Utils.try_get_grid_man()
	var curr_tile: Tile = grid.get_tile_objects(Model.ObjectTypes.TILE, owning_character.grid_coordinates)
	var neighbor: Tile = targets[0]
	neighbor.paths
