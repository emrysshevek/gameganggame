class_name CharacterSprite extends GridSprite

#region signals
signal moved(which_character_id, new_tile_position)
#endregion

#region properties
var character_id:int = 0
#endregion

#region methods
func move(new_grid_position:Vector2, relative_change:Vector2):
	#concerned about this shadowing same method from grid_sprite?
	grid_coordinates = new_grid_position
	position += relative_change
	moved.emit(character_id, new_grid_position)
#endregion
