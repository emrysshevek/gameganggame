extends Card

## All characters adjacent to you draw 1 card. You also draw one card

func _trigger_play_ability() -> void:
	var game_scene:GameScene = Utils.try_get_game_scene()
	for each_character in game_scene.characters:
		if abs(each_character.grid_coordinates.x - owning_character.grid_coordinates.x) <= 1 and abs(each_character.grid_coordinates.y - owning_character.grid_coordinates.y) <= 1:
			each_character.my_screen.card_manager.draw(1)
	super._trigger_play_ability()
