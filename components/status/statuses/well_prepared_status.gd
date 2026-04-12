class_name WellPreparedStatus
extends Status

## Well Prepared X: At the start of the next X turns, draw a card

var character: Character

func _init(val:=3) -> void:
	super._init(val)
	status_name = "Well Prepared"
	

func apply(target: Node) -> bool:
	if not target is Character:
		return false
	
	super.apply(target)
	character = target as Character
	
	character.started_turn.connect(_on_turn_started)
	return true
	

func trigger_effect() -> void:
	super.trigger_effect()
	character.my_screen.card_manager.draw()
	value -= 1
	if value == 0:
		remove_status.emit(self)


func _on_turn_started(character: Character) -> void:
	trigger_effect()
