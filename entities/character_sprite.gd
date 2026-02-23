class_name CharacterSprite extends GridSprite

#region signals
signal moved(which_character, new_tile_position)
#endregion

#region properties
var character_id:int = 0
var character_ref:int #will be character, currently player

var movement:int = 0 #we probably want to move this into the character obj later

@onready var input_man:PlayerInputManager = InputManager.get_controller_manager()
@onready var fake_state_machine:String = "character" #character, cursor, blank
#endregion

#region methods
func _process(delta: float) -> void:
	if fake_state_machine == "character":
		_handle_input()
	else:
		pass

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
