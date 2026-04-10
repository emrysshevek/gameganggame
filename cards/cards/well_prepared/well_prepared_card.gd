extends Card


func _trigger_play_ability() -> void:
	var characters := Utils.try_get_game_scene().characters
	
	for character in characters:
		character.status_manager.add_status(WellPreparedStatus.new())
		
	super._trigger_play_ability()
