class_name FeelNoPainStatus
extends CharacterStatus


## Feel No Pain X: For next X rounds, gain B when taking damage


func _init(val:int) -> void:
	super._init(val)
	status_name = "Feel No Pain"


func apply(target: Node) -> bool:
	if not super.apply(target):
		return false
		
	Events.character_damaged.connect(_on_character_damaged)
	Events.round_ended.connect(_on_round_ended)
	return true
	

func trigger_effect() -> void:
	super.trigger_effect()
	var value_man := Utils.try_get_value_manager()
	value_man._increase_value(Model.CreatureValue.BRAVERY, 1)
	

func _on_character_damaged(_character: Character, _amount:int, _source) -> void:
	if _character == character:
		trigger_effect()
		
		
func _on_round_ended() -> void:
	remove_status.emit(self)
