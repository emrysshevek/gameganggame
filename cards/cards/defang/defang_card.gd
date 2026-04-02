extends Card

func _trigger_play_ability() -> void:
	var grid_man: GridManager = Utils.try_get_grid_man()
	var tile: Tile = grid_man.get_tile_objects(Model.ObjectTypes.HAZARD, owning_character.grid_coordinates)
	if tile.hazard != null:
		tile.hazard.queue_free()
		tile.hazard = null
	super._trigger_play_ability()
