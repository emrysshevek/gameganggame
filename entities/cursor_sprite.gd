class_name CursorSprite extends GridSprite

#region properties
var character_id:int = 0

@onready var fake_state_machine:String = "character" #character, cursor
#endregion

func _process(delta: float) -> void:
	if fake_state_machine == "cursor" && input_man != null:
		_handle_input()
	else:
		pass

func _handle_input():
	if input_man.is_action_just_released("move_up"):
		move_request.emit(self, Vector2(grid_coordinates.x, grid_coordinates.y - 1))
	elif input_man.is_action_just_released("move_right"):
		move_request.emit(self, Vector2(grid_coordinates.x + 1, grid_coordinates.y))
	elif input_man.is_action_just_released("move_down"):
		move_request.emit(self, Vector2(grid_coordinates.x, grid_coordinates.y + 1))
	elif input_man.is_action_just_released("move_left"):
		move_request.emit(self, Vector2(grid_coordinates.x - 1, grid_coordinates.y))
