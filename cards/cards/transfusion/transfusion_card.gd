extends Card

## target other player in range 5 to give them +3 move

func _trigger_play_ability() -> void:
	if targets.is_empty() == false:
		var target:Character = targets[0] as Character
		owning_character.take_damage(1)
		target.heal(1)
	else:
		owning_character.play_error_pop_up("must target a player character")
	#so that you don't get stuck in targetting mode if you target a tile without a player character the card
	#just discards and has no direct effect
	super._trigger_play_ability()
