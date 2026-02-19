class_name CursorSprite extends GridSprite

#region properties
var character_id:int = 0

@onready var fake_state_machine:String = "character" #character, cursor
#endregion

func _process(delta: float) -> void:
	if fake_state_machine == "cursor":
		pass #movement works
	else:
		pass
