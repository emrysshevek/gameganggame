class_name GridSprite extends Sprite2D

#region properties
var grid_coordinates:Vector2
#endregion

#region methods
func set_visual_position(coords:Vector2):
	position = coords
	
func set_sprite(sprite_to_load:Resource):
	texture = sprite_to_load
	
func set_minimap_sprite(sprite_to_load:Resource, color_to_set:Color):
	var new_minimap_sprite = Sprite2D.new()
	new_minimap_sprite.texture = sprite_to_load
	new_minimap_sprite.set_visibility_layer(2)
	new_minimap_sprite.offset = offset
	new_minimap_sprite.scale = Vector2(2,2)
	new_minimap_sprite.self_modulate = color_to_set
	add_child(new_minimap_sprite)
	
func move(new_grid_position:Vector2, relative_change:Vector2):
	grid_coordinates = new_grid_position
	position += relative_change
	
func set_sprite_scale(new_scale:Vector2):
	scale = new_scale
	
func set_custom_offset(offset_amount:Vector2):
	offset = offset_amount
	
func get_scaled_size():
	return texture.get_size() * scale
#endregion
