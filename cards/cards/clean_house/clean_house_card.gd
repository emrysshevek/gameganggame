extends Card

##pick up all resource cards on current tile

func _trigger_play_ability() -> void:
	var tile_position:Vector2 = owning_character.grid_coordinates
	var grid_man:GridManager = Utils.try_get_grid_man()
	grid_man.floor_maps[owning_character.current_floor][tile_position.x][tile_position.y].pickup_cards(owning_character)
	super._trigger_play_ability()
