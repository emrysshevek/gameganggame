extends Card

func _trigger_play_ability() -> void:
	var grid_man: GridManager = Utils.try_get_grid_man()
	var tile: Tile = grid_man.get_tile(owning_character.grid_coordinates)
	### If this gives an error there is some kind of race condition happening
	tile.hazard.queue_free()
	###
	tile.hazard = null
	tile.redraw_tile()
	super._trigger_play_ability()
