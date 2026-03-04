class_name CharacterSprite extends GridSprite

#region signals
signal moved(which_character, new_tile_position)
#endregion

#region properties
var character_id:int = 0
var character_ref:int #will be character, currently player

var movement:int = 0 #we probably want to move this into the character obj later
@export var input_state_machine: PlayerInputStateMachine
#endregion

#region methods
func _process(_delta: float) -> void:
	if input_state_machine.current_state == Model.InputState.MOVE:
		_handle_input()


func move(new_grid_position:Vector2, new_screen_position:Vector2):
	#concerned about this shadowing same method from grid_sprite?
	grid_coordinates = new_grid_position
	position = new_screen_position
	move_remote_camera(position)
	moved.emit(self, new_grid_position)
	
func _handle_input():
	if movement > 0:
		if input_man.is_action_just_released("move_up"):
			move_request.emit(self, Vector2(grid_coordinates.x, grid_coordinates.y - 1))
		elif input_man.is_action_just_released("move_right"):
			move_request.emit(self, Vector2(grid_coordinates.x + 1, grid_coordinates.y))
		elif input_man.is_action_just_released("move_down"):
			move_request.emit(self, Vector2(grid_coordinates.x, grid_coordinates.y + 1))
		elif input_man.is_action_just_released("move_left"):
			move_request.emit(self, Vector2(grid_coordinates.x - 1, grid_coordinates.y))
		
#endregion
