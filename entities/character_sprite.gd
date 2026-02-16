class_name CharacterSprite extends Sprite2D

#region signals
signal moved(which_character_id, new_tile_position)
#endregion

#region properties
var character_id:int = 0
@onready var _sprite_texture:Texture2D = load("res://art/test_cat.png") #dynamically load from character obj later
var grid_coordinates:Vector2
#endregion

#region methods
func set_visual_position(coords:Vector2):
	position = coords
	
func set_sprite():
	texture = load("res://art/test_cat.png")
	
func move(new_grid_position:Vector2, relative_change:Vector2):
	grid_coordinates = new_grid_position
	position += relative_change 
	moved.emit(character_id, new_grid_position)
#endregion
