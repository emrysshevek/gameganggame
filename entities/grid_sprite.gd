class_name GridSprite extends Sprite2D

#region properties
var grid_coordinates:Vector2
#endregion

#region methods
func set_visual_position(coords:Vector2):
	position = coords
	
func set_sprite(sprite_to_load:Resource):
	texture = sprite_to_load
	
func move(new_grid_position:Vector2, relative_change:Vector2):
	grid_coordinates = new_grid_position
	position += relative_change
	
func set_sprite_scale(new_scale:Vector2):
	scale = new_scale
#endregion
