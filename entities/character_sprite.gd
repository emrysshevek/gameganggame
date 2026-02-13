class_name CharacterSprite extends Sprite2D

#region properties
@onready var _sprite_texture:Texture2D = load("res://art/test_cat.png") #dynamically load from character obj later
#endregion

#region methods
func set_visual_position(coords:Vector2):
	position = coords
	
func set_sprite():
	texture = _sprite_texture
#endregion
