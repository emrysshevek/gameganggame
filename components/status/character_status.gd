class_name CharacterStatus
extends Status

var character: Character


func _init(val:int) -> void:
	super._init(val)
	status_name = "Character Status (REPLACE)"
	

func apply(target: Node) -> bool:
	if not target is Character:
		return false
	
	super.apply(target)
	character = target as Character
	return true
