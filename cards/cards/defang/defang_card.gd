extends Card


func _trigger_play_ability() -> void:
	var hazard := targets[0] as Hazard
	var grid_man := Utils.try_get_grid_man()
	var tile := grid_man.get_tile(hazard.grid_coordinates)
	tile.hazard.queue_free()
