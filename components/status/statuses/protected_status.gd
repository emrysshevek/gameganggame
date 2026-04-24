class_name ProtectedStatus
extends CharacterStatus


## Protected X: Prevents the next X hazards from triggering on the source character


var hazard: Hazard


func _init(val:int) -> void:
	status_name = "Protected"
	value = val
	
	
func apply(target: Node) -> bool:
	if not super.apply(target):
		return false
	
	Events.hazard_will_trigger.connect(_on_hazard_will_trigger)
	return true
	
	
func trigger_effect() -> void:
	hazard.block_trigger = true
	super.trigger_effect()
	
	value -= 1
	if value <= 0:
		remove_status.emit(self)


func _on_hazard_will_trigger(hazard: Hazard, character: Character) -> void:
	if character != self.character:
		return 
		
	self.hazard = hazard
	
	trigger_effect()
