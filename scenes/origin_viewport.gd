class_name OriginViewport extends Node

enum viewport_names{p1, p2, p3, p4, origin, minimap}

#region properties
@onready var character_sprite = preload("res://entities/character_sprite.tscn")
@onready var player_viewport = preload("res://scenes/player_subviewport.tscn")
@onready var grid_sprite = preload("res://entities/grid_sprite.tscn")
@onready var cursor_sprite = preload("res://entities/cursor_sprite.tscn")
var _player_sub_viewports:Dictionary[viewport_names, PlayerSubViewport]
@onready var _world:World2D = $OriginViewportContainer/OriginViewport.find_world_2d()
@onready var grid_man:GridManager = $OriginViewportContainer/OriginViewport/GridManager
@onready var _origin_viewport:SubViewport = $OriginViewportContainer/OriginViewport
@onready var _viewport_organizer_vertical:VBoxContainer = $VertViewportOrganizer
@onready var _viewport_organizer_top_horizontal:HBoxContainer = $VertViewportOrganizer/TopHorViewportOrganizer
@onready var _viewport_organizer_bottom_horizontal:HBoxContainer = $VertViewportOrganizer/BotHorViewportOrganizer
@onready var _minimap_zoom:Vector2 = Vector2(0.2,0.2)
@onready var _minimap_size:Vector2 = Vector2(200,200)
var _player_view_zoom:Vector2 = Vector2(1.6,1.6)
var _minimap_coord_1p:Vector2
var _minimap_coord_2p:Vector2
var _minimap_coord_4p:Vector2
var _camera_limits:Dictionary[String,int]
var _tile_size:Vector2
var _player_viewport_size:Vector2 # = Vector2(100,100)#Vector2(DisplayServer.window_get_size().x / 2,DisplayServer.window_get_size().y / 2)
@onready var player_to_character_sprite:Dictionary[Player, CharacterSprite]
var player_cursors:Dictionary[int, Sprite2D]
var number_of_players:int
var character_sprites:Array[CharacterSprite]
var _input_managers: Array[PlayerInputManager]
@onready var player_viewport_names = [viewport_names.p1, viewport_names.p2, viewport_names.p3, viewport_names.p4]
#endregion

#region methods
func _ready() -> void:
	_tile_size = grid_man.tile_size
	#moving origin viewport container and its children out of the regular viewable screen space so it doesn't peek through
	$OriginViewportContainer.position.y = -1 * (grid_man.map_height * _tile_size.y)
	#setting up camera limits so that they aren't able to move too far out of the game area
	_camera_limits["Left"] = 0
	_camera_limits["Top"] = 0
	_camera_limits["Right"] = (grid_man.map_width * _tile_size.x)
	_camera_limits["Bottom"] = (grid_man.map_height * _tile_size.y)
	#minimap placement and size configuration
	_minimap_size = Vector2(((grid_man.map_width * _tile_size.x) * _minimap_zoom.x), ((grid_man.map_height * _tile_size.y) * _minimap_zoom.y))
	_minimap_coord_1p = Vector2(DisplayServer.window_get_size().x - _minimap_size.x, 0)
	_minimap_coord_2p = Vector2(DisplayServer.window_get_size().x - _minimap_size.x, (DisplayServer.window_get_size().y / 2) - _minimap_size.y/2)
	_minimap_coord_4p = Vector2((DisplayServer.window_get_size().x / 2) - _minimap_size.x/2, (DisplayServer.window_get_size().y / 2) - _minimap_size.y/2)
	setup_minimap()
	#setup_player_testing()

func setup_minimap():
	number_of_players = 4 #testing for easy config of # of players
	#setting up the minimap viewport
	var minimap_viewport = player_viewport.instantiate()
	add_child(minimap_viewport)
	minimap_viewport.set_viewport_world(_world)
	minimap_viewport.set_bounds(_minimap_size)
	minimap_viewport.set_zoom(_minimap_zoom)
	minimap_viewport.toggle_background()
	minimap_viewport.set_fade(0.8)
	var culling_dictionary:Dictionary[int,bool] = {0:true, 1:true}
	minimap_viewport.set_layers_visible(culling_dictionary)
	var minimap_camera_center_position = Vector2((grid_man.map_width * _tile_size.x) / 2, ( (grid_man.map_height * _tile_size.y)) / 2)
	minimap_viewport.move_camera(minimap_camera_center_position)
	_player_sub_viewports[viewport_names.minimap] = minimap_viewport

func add_character() -> CharacterSprite:
	var new_character_sprite = character_sprite.instantiate()
	new_character_sprite.set_sprite(load("res://art/test_cat.png"))
	new_character_sprite.set_sprite_scale(Vector2(0.5,0.5))
	new_character_sprite.set_custom_offset(_tile_size - new_character_sprite.get_scaled_size())
	_origin_viewport.add_child(new_character_sprite)
	character_sprites.append(new_character_sprite)
	_input_managers.append(new_character_sprite.input_man)
	
	var grid_man_origin = grid_man.global_position
	var test_player_coords:Array = [Vector2(1,1), Vector2(15,1), Vector2(6,14), Vector2(12,19)]
	var coords = test_player_coords[len(character_sprites)-1]
	
	grid_man.testing_map_distance_algorithm(Vector2(coords),3,0)
	new_character_sprite.grid_coordinates = coords
	#_player_sub_viewports[player_viewport_names[each_player]].visible = true
	new_character_sprite.set_visual_position(Vector2(coords.x * _tile_size.x, coords.y * _tile_size.y))
	#character_sprites[each_player].set_remote_camera_transform(_player_sub_viewports[player_viewport_names[each_player]].camera)
	new_character_sprite.move_request.connect(grid_man._on_grid_sprite_move_request)
	new_character_sprite.set_minimap_sprite(load("res://art/character_minimap_icon.png"), Color("#f3e100"))
	new_character_sprite.set_type(GridSprite.sprite_types.character)
	return new_character_sprite

		
func create_cursor(which_player_id:int, tile_position:Vector2):
	var new_cursor:CursorSprite = cursor_sprite.instantiate()
	#currently cursor breaks if its not a child of grid man, size and placement is all wrong
	new_cursor.input_man = character_sprites[which_player_id].input_man
	grid_man.add_child(new_cursor)
	player_cursors[which_player_id] = new_cursor
	new_cursor.set_sprite(load("res://art/cursor.png"))
	new_cursor.grid_coordinates = tile_position
	new_cursor.set_visual_position(Vector2(character_sprites[0].grid_coordinates.x * _tile_size.x, character_sprites[0].grid_coordinates.y * _tile_size.y))
	new_cursor.set_type(GridSprite.sprite_types.ui)
	new_cursor.set_remote_camera_transform(_player_sub_viewports[player_viewport_names[which_player_id]].camera)
	new_cursor.move_request.connect(grid_man._on_grid_sprite_move_request)
	return new_cursor
				
#region testing methods
#func _process(delta: float) -> void:
	#for i in range(Config.MAX_PLAYER_COUNT):
		#_handle_input(i)

#func _handle_input(player_id: int):
	##this will eventually be in the player input handler instead
		#if _input_managers[player_id].is_action_just_released(Model.Action.TOGGLE_MAP):
			##testing switching to 'look around mode'
			#if player_cursors.has(player_id):
				#grid_man.set_highlight_tiles(grid_man.get_reachable_tiles(0, character_sprites[player_id].grid_coordinates, 3), false, false)
				#player_cursors[player_id].queue_free()
				#player_cursors.erase(player_id)
				#character_sprites[player_id].set_remote_camera_transform(_player_sub_viewports[player_viewport_names[player_id]].camera)
				#character_sprites[player_id].fake_state_machine = "character"
			#else:
				#create_cursor(player_id, character_sprites[player_id].grid_coordinates).fake_state_machine = "cursor"
				#character_sprites[player_id].fake_state_machine = "cursor"
		
#func setup_player_testing():

#endregion
		
#endregion
