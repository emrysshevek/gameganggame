class_name CursorSprite extends GridSprite

#region properties
var character_id:int
var character_ref:Character


@export var input_state_machine: PlayerInputStateMachine
#endregion

func _process(_delta: float) -> void:
	if input_state_machine.current_state == Model.InputState.CURSOR || input_state_machine.current_state == Model.InputState.TARGET_CURSOR:
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
		elif input_man.is_action_just_released(Model.Action.SELECT) && input_state_machine.current_state == Model.InputState.TARGET_CURSOR:
			var current_card = character_ref.get_my_current_playing_card()
			if current_card != null:
				var grid_man = Utils.try_get_grid_man()
				var objects = grid_man.get_tile(grid_coordinates).get_contents([current_card.targets_required.type])
				if len(objects) > 0:
					current_card.try_add_target(objects[0])
