class_name GridSprite extends Sprite2D

enum sprite_types{character, ui}

#region signals
signal move_request(which_sprite, requested_position)
#endregion

#region properties
var grid_coordinates:Vector2
var _remote_camera_transform:RemoteTransform2D
var type:sprite_types
#endregion

#region methods
func set_visual_position(coords:Vector2):
	position = coords
	move_remote_camera(coords)
	
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
	
func move(new_grid_position:Vector2, new_screen_position:Vector2):
	grid_coordinates = new_grid_position
	position = new_screen_position
	move_remote_camera(position)
	
func set_sprite_scale(new_scale:Vector2):
	scale = new_scale
	
func set_custom_offset(offset_amount:Vector2):
	offset = offset_amount
	
func get_scaled_size():
	return texture.get_size() * scale
	
func set_remote_camera_transform(following_camera:Camera2D):
	var new_transform = RemoteTransform2D.new()
	new_transform.update_rotation = false
	new_transform.update_scale = false
	new_transform.remote_path = following_camera.get_path()
	_remote_camera_transform = new_transform
	add_child(_remote_camera_transform)
	
func move_remote_camera(new_position:Vector2):
	if _remote_camera_transform != null:
		_remote_camera_transform.global_position = new_position
		
func set_type(type_to_set:sprite_types):
	type = type_to_set
#endregion
