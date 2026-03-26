extends Card


func _trigger_play_ability() -> void:
	owning_character.my_screen.card_manager.draw()
