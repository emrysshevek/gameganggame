class_name WellPreparedStatus
extends Status

var character: Character

func _init(val:=3) -> void:
	super._init(val)
	status_name = "Well Prepared"
	

func apply(target: Node) -> bool:
	if not target is Character:
		return false
		
	character = target as Character
	
	# TODO: connect to turn start signal
	return true
	

func _on_turn_started() -> void:
	character.my_screen.card_manager.draw()
	value -= 1
	if value == 0:
		remove()
