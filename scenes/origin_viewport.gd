class_name OriginViewport extends Node

enum viewport_names{p1, p2, p3, p4, origin, minimap}

#region properties
#loading scenes used
@onready var character_sprite = preload("res://character/character_sprite.tscn")
@onready var player_viewport = preload("res://scenes/player_subviewport.tscn")
@onready var grid_sprite = preload("res://entities/grid_sprite.tscn")
@onready var cursor_sprite = preload("res://entities/cursor_sprite.tscn")
#assigning scene children to vars
@onready var world:World2D = $OriginViewportContainer/OriginViewport.find_world_2d()
@onready var grid_man:GridManager = $OriginViewportContainer/OriginViewport/GridManager
@onready var _origin_viewport:SubViewport = $OriginViewportContainer/OriginViewport
#camera limits determine how far off the map the camera can go, currently it can't go off the map at all
var _camera_limits:Dictionary[String,int]
#tile size in pixels, used to draw them in the correct spots
var _tile_size:Vector2
var character_sprites:Array[CharacterSprite]
var _input_managers: Array[PlayerInputManager]
@onready var player_viewport_names = [viewport_names.p1, viewport_names.p2, viewport_names.p3, viewport_names.p4]
#endregion

#region methods
func _ready() -> void:
	#getting the size of the tiles from grid man, who knows the size of the tiles
	_tile_size = grid_man.tile_size

	#moving origin viewport container and its children out of the regular viewable screen space so it doesn't peek through
	$OriginViewportContainer.position.y = -1 * (grid_man.map_height * _tile_size.y)

	#setting up camera limits so that they aren't able to move too far out of the game area
	_camera_limits["Left"] = 0
	_camera_limits["Top"] = 0
	_camera_limits["Right"] = (grid_man.map_width * _tile_size.x)
	_camera_limits["Bottom"] = (grid_man.map_height * _tile_size.y)


func add_character(new_character:Character) -> CharacterSprite:
	#adds a character that is created in game_scene to the origin viewport as a child
	#if a character is not added to the viewport they will not be visible at all in the game
	_origin_viewport.add_child(new_character)

	#setting up the characters sprite and then their cursor
	var new_character_sprite = character_sprite.instantiate()
	new_character.bind_character_sprite(new_character_sprite)
	new_character.move_request.connect(grid_man._on_object_move_request)
	new_character_sprite.set_sprite(load("res://art/test_cat.png"))
	new_character_sprite.set_sprite_scale(Vector2(0.5,0.5))
	new_character_sprite.set_custom_offset(_tile_size - new_character_sprite.get_scaled_size())
	character_sprites.append(new_character_sprite)
	_input_managers.append(new_character_sprite.input_man)
	create_cursor(new_character, new_character_sprite.grid_coordinates)

	#determining spawn location of the character and assigning it
	var grid_man_origin = grid_man.global_position
	var test_player_coords:Array = [Vector2(10,10), Vector2(11,10), Vector2(10,11), Vector2(11,11)]
	var coords = test_player_coords[len(character_sprites)-1]
	new_character.grid_coordinates = coords

	#revealing starting tiles around each player after they spawn
	for each_tile in grid_man.get_reachable_tiles(0, new_character.grid_coordinates, 1):
		each_tile.explore(new_character)
		if each_tile.grid_coordinates == new_character.grid_coordinates:
			each_tile.call_deferred("enter", new_character)

	#setting up the character sprites visual position and minimap sprite
	new_character_sprite.set_visual_position(Vector2(coords.x * _tile_size.x, coords.y * _tile_size.y))
	new_character_sprite.set_minimap_sprite(load("res://art/character_minimap_icon.png"), Color("#f3e100"))
	new_character_sprite.set_type(GridSprite.sprite_types.character)
	return new_character_sprite


func create_cursor(new_character:Character, tile_position:Vector2):
	#called from create_character above, this sets up the cursor for the new character
	var new_cursor:CursorSprite = cursor_sprite.instantiate()
	new_character.bind_cursor_sprite(new_cursor)

	#sets the cursor to use the same input_man as the character
	new_cursor.input_man = character_sprites[new_character.character_id].input_man

	#set up cursor sprite and visual/tile position
	new_cursor.set_sprite(load("res://art/cursor.png"))
	new_cursor.grid_coordinates = tile_position
	new_cursor.set_visual_position(Vector2(character_sprites[0].grid_coordinates.x * _tile_size.x, character_sprites[0].grid_coordinates.y * _tile_size.y))

	#move request signal used by cursor and by characters to signal they are trying to move
	new_cursor.move_request.connect(grid_man._on_object_move_request)

	#setting the cursor as initially invisible until it is used
	new_cursor.visible = false
	return new_cursor

#endregion
