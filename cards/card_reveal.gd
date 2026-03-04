extends Card


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#region Private Methods
func _trigger_play_ability() -> void:
	targets.append(owning_character)
	owning_character.movement += 3
	

func _trigger_discard_ability() -> void:
	targets.append(owning_character)
	owning_character.movement += 1
#endregion
