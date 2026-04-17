class_name NoTimeToWasteStatus
extends CharacterStatus

var can_apply: bool = true

func _init(val: int) -> void:
	super._init(val)
	value = val
	status_name = "No Time To Waste"
	

func apply(target: Node) -> bool:
	if not super.apply(target):
		return false
		
	Events.character_movement_value_changed.connect(_on_character_movement_value_changed)
	Events.round_ended.connect(_on_round_ended)
	return true
	
	
func trigger_effect() -> void:
	if not can_apply:
		can_apply = true
		return
		
	can_apply = false
	character.movement += 1
	super.trigger_effect()
	

func _on_character_movement_value_changed(character: Character, old_val: int, new_val: int) -> void:
	if not self.character == character:
		return
		
	if new_val <= old_val:
		return
		
	trigger_effect()
	
	
func _on_round_ended() -> void:
	value -= 1
	if value <= 0:
		remove_status.emit(self)
	
