class_name CursorSprite extends GridSprite

#region properties
var character_id:int = 0


@export var input_state_machine: PlayerInputStateMachine
#endregion

func _process(_delta: float) -> void:
	if input_state_machine.current_state == Model.InputState.CURSOR || input_state_machine.current_state == Model.InputState.TARGET:
		_handle_input()

func toggle_visibility():
	self.visible = !self.visible

func _handle_input():
	if visible == true:
		if input_man.is_action_just_released("move_up"):
			move_request.emit(self, Vector2(grid_coordinates.x, grid_coordinates.y - 1))
		elif input_man.is_action_just_released("move_right"):
			move_request.emit(self, Vector2(grid_coordinates.x + 1, grid_coordinates.y))
		elif input_man.is_action_just_released("move_down"):
			move_request.emit(self, Vector2(grid_coordinates.x, grid_coordinates.y + 1))
		elif input_man.is_action_just_released("move_left"):
			move_request.emit(self, Vector2(grid_coordinates.x - 1, grid_coordinates.y))
		elif input_man.is_action_just_released(Model.Action.SELECT) && input_state_machine.current_state == Model.InputState.TARGET:
			get_tile_object_request.emit("", grid_coordinates)
			#add the selected tile/object to the 'target' for the card being played in input_state_machine
