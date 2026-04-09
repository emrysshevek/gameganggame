class_name CursorSprite extends GridSprite

#region properties
var character_id:int
var character_ref:Character


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
			if character_ref.get_my_current_playing_card() != null:
				var current_card = character_ref.get_my_current_playing_card()
				var grid_man = Utils.try_get_grid_man()
				if current_card.validate_target(grid_man.get_tile_objects(current_card.get_remaining_target_types()[0], grid_coordinates), false) == true:		
					current_card.check_targetting_finished()
			#add the selected tile/object to the 'target' for the card being played in input_state_machine
