class_name GridSprite extends Sprite2D

enum sprite_types{character, ui}

#region signals
signal move_request(which_sprite, requested_position)
#endregion

#region properties
@export var types: Array[Model.ObjectTypes] = [Model.ObjectTypes.ENTITY]

var grid_coordinates:Vector2

#remote camera transform is used when one of the players viewports are following a character/cursor around
var _remote_camera_transform:RemoteTransform2D
var input_man:PlayerInputManager
#endregion

#region methods
func set_visual_position(coords:Vector2):
	#used to set the visual position of the sprite independently of moving it on the grid
	#this is currently only used when first setting up the character sprite and the cursor
	#all other movement of grid sprites occurs via grid_man
	#this may not be necessary anymore but could be helpful for adjusting sprite position independent of grid
	position = coords
	move_remote_camera(coords)
	
func set_input_man(input_manager:PlayerInputManager) -> void:
	input_man = input_manager
	
func set_sprite(sprite_to_load:Resource):
	texture = sprite_to_load
	
func set_minimap_sprite(sprite_to_load:Resource, color_to_set:Color):
	#sets up the sprite that will represent this grid sprite on the minimap
	#if not set then the grid sprite will just appear all tiny on the minimap and might be hard to identify
	var new_minimap_sprite = Sprite2D.new()
	new_minimap_sprite.texture = sprite_to_load
	new_minimap_sprite.set_visibility_layer(2)
	new_minimap_sprite.offset = offset
	new_minimap_sprite.scale = Vector2(2,2)
	new_minimap_sprite.self_modulate = color_to_set
	add_child(new_minimap_sprite)
	
func move(new_grid_position:Vector2, new_screen_position:Vector2):
	#used for movement of grid sprite on grid
	#this is called from grid_man->move object and shouldn't be called directly
	grid_coordinates = new_grid_position
	position = new_screen_position
	move_remote_camera(position)
	
func set_sprite_scale(new_scale:Vector2):
	scale = new_scale
	
func set_custom_offset(offset_amount:Vector2):
	#used for correctly centering the sprite on the tile, or moving it off center if desired
	offset = offset_amount
	
func get_scaled_size():
	#useful if you need to determine how much space the grid sprite takes up visually
	return texture.get_size() * scale
	
func set_remote_camera_transform(following_camera:Camera2D):
	#this causes the camera to track this grid sprite object
	#currently used for characters and cursor sprite moving on the map
	var new_transform = RemoteTransform2D.new()
	new_transform.update_rotation = false
	new_transform.update_scale = false
	new_transform.remote_path = following_camera.get_path()
	_remote_camera_transform = new_transform
	add_child(_remote_camera_transform)
	
func move_remote_camera(new_position:Vector2):
	#moves the aforementioned remote camera via the transform
	if _remote_camera_transform != null:
		_remote_camera_transform.global_position = new_position
		
func set_type(type_to_set:Model.ObjectTypes):
	#type of the grid sprite, currently used for card targetting
	types.append(type_to_set)
	
	
func damage_animation():
	#simple little 'animation' that happens when a character is damaged
	var new_tween = self.create_tween()
	var previous_color = self.self_modulate
	new_tween.tween_property(self, "self_modulate", Color("ffffff"), Config.animation_speed * 0.2)
	new_tween.tween_property(self, "self_modulate", Color("#b82d1d"), Config.animation_speed * 0.5)
	new_tween.tween_property(self, "self_modulate", Color("ffffff"), Config.animation_speed * 0.2)
	new_tween.tween_property(self, "self_modulate", Color("#b82d1d"), Config.animation_speed * 0.5)
	new_tween.tween_property(self, "self_modulate", Color("ffffff"), Config.animation_speed * 0.2)
	new_tween.tween_property(self, "self_modulate", previous_color, Config.animation_speed)

func play_pop_up(text:String, _set_color:Color):
	#used to play a text indication of some action occuring, such as taking damage or picking up a card
	var new_pop_up_label = Label.new()
	#new_pop_up_label.visible = false
	new_pop_up_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	new_pop_up_label.text = text
	new_pop_up_label.position = Vector2(self.get_scaled_size().x / 2, 0)
	new_pop_up_label.self_modulate = Color("ffffff00")
	#set label theme here maybe?
	add_child(new_pop_up_label)
	var new_tween = self.create_tween()
	new_tween.tween_property(new_pop_up_label, "position", new_pop_up_label.position - Vector2(0,15), Config.animation_speed)
	new_tween.parallel().tween_property(new_pop_up_label, "self_modulate", Color(_set_color), Config.animation_speed)
	new_tween.tween_property(new_pop_up_label, "self_modulate", Color("ffffff00"), Config.animation_speed * 2)
#endregion
