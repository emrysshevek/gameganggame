extends Card


func _trigger_play_ability() -> void:
	for character: Character in Utils.try_get_game_scene().characters:
		character.status_manager.add_status(NoTimeToWasteStatus.new(1))
	super._trigger_play_ability()
