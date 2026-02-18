class_name CharacterSprite extends GridSprite

#region signals
signal moved(which_character_id, new_tile_position)
#endregion

#region properties
var character_id:int = 0
var character_ref:int #will be character, currently player
#endregion

#region methods
func move(new_grid_position:Vector2, new_screen_position:Vector2):
	#concerned about this shadowing same method from grid_sprite?
	grid_coordinates = new_grid_position
	position = new_screen_position
	move_remote_camera(position)
	moved.emit(character_id, new_grid_position)
#endregion
