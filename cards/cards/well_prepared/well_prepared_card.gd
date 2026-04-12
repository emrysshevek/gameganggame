extends Card

## Applies Well Prepared 3 (start of next three turns, draw a card)

func _trigger_play_ability() -> void:
	var characters := Utils.try_get_game_scene().characters
	
	for character in characters:
		character.status_manager.add_status(WellPreparedStatus.new(3))
		
	super._trigger_play_ability()
