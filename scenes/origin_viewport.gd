class_name OriginViewport extends Node

enum viewport_names{p1, p2, p3, p4, origin, minimap}

#region properties
@onready var character_sprite = preload("res://entities/character_sprite.tscn")
@onready var player_viewport = preload("res://scenes/player_subviewport.tscn")
@onready var grid_sprite = preload("res://entities/grid_sprite.tscn")
var _player_sub_viewports:Dictionary[viewport_names, PlayerSubViewport]
@onready var _world:World2D = $OriginViewportContainer/OriginViewport.find_world_2d()
@onready var grid_man:GridManager = $OriginViewportContainer/OriginViewport/GridManager
var _viewport_organizer_vertical:VBoxContainer
var _viewport_organizer_top_horizontal:HBoxContainer
var _viewport_organizer_bottom_horizontal:HBoxContainer
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
var player_reticules:Dictionary[Player, Sprite2D]
var number_of_players:int
var character_sprites:Array
@onready var testing_player:Player = Player.new()
var _input_managers: Array[PlayerInputManager]
#endregion

#region methods
func _ready() -> void:
	_tile_size = grid_man.tile_size
	for i in range(Config.MAX_PLAYER_COUNT):
		_input_managers.append(InputManager.get_controller_manager())
	#moving origin viewport container and its children out of the regular viewable screen space so it doesn't peek through
	$OriginViewportContainer.position.y = -1 * (grid_man.map_height * _tile_size.y)
	_viewport_organizer_vertical = $VertViewportOrganizer
	_viewport_organizer_top_horizontal = $VertViewportOrganizer/TopHorViewportOrganizer
	_viewport_organizer_bottom_horizontal = $VertViewportOrganizer/BotHorViewportOrganizer
	#_viewport_organizer_vertical.custom_minimum_size = DisplayServer.window_get_size()
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
	setup_viewports([0,1,2,3])
	setup_player_testing()

func setup_viewports(players:Array):
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
	##adding viewports to the containers and making containers visible
	var player_viewport_names = [viewport_names.p1, viewport_names.p2, viewport_names.p3, viewport_names.p4]
	for each_num in number_of_players:
		var new_player_viewport = player_viewport.instantiate()
		_player_sub_viewports[player_viewport_names[each_num]] = new_player_viewport
		var new_character_sprite = character_sprite.instantiate()
		new_character_sprite.set_sprite(load("res://art/test_cat.png"))
		new_character_sprite.set_sprite_scale(Vector2(0.5,0.5))
		new_character_sprite.set_custom_offset(_tile_size - new_character_sprite.get_scaled_size())
		grid_man.add_child(new_character_sprite)
		character_sprites.append(new_character_sprite)
	##configuration of containers and viewports based on number of players
	if number_of_players == 1:
		_viewport_organizer_vertical.add_child(_player_sub_viewports[viewport_names.p1])
		_player_sub_viewports[viewport_names.minimap].global_position = _minimap_coord_1p
	elif number_of_players == 2:
		_viewport_organizer_top_horizontal.visible = true
		_viewport_organizer_bottom_horizontal.visible = true
		_viewport_organizer_top_horizontal.add_child(_player_sub_viewports[viewport_names.p1])
		_viewport_organizer_bottom_horizontal.add_child(_player_sub_viewports[viewport_names.p2])
		_player_sub_viewports[viewport_names.minimap].global_position = _minimap_coord_2p
	elif number_of_players == 3:
		_viewport_organizer_top_horizontal.visible = true
		_viewport_organizer_bottom_horizontal.visible = true
		_viewport_organizer_top_horizontal.add_child(_player_sub_viewports[viewport_names.p1])
		_viewport_organizer_bottom_horizontal.add_child(_player_sub_viewports[viewport_names.p2])
		_viewport_organizer_bottom_horizontal.add_child(_player_sub_viewports[viewport_names.p3])
		_player_sub_viewports[viewport_names.minimap].reparent(_viewport_organizer_top_horizontal)
		#toggling background off for minimap as it will be one of the four screen tiles with 3 players
		_player_sub_viewports[viewport_names.minimap].toggle_background()
	elif number_of_players == 4:
		_viewport_organizer_top_horizontal.visible = true
		_viewport_organizer_bottom_horizontal.visible = true
		_viewport_organizer_top_horizontal.add_child(_player_sub_viewports[viewport_names.p1])
		_viewport_organizer_bottom_horizontal.add_child(_player_sub_viewports[viewport_names.p2])
		_viewport_organizer_bottom_horizontal.add_child(_player_sub_viewports[viewport_names.p3])
		_viewport_organizer_top_horizontal.add_child(_player_sub_viewports[viewport_names.p4])
		_player_sub_viewports[viewport_names.minimap].global_position = _minimap_coord_4p
	else:
		print("invalid number of players:" + str(players.size()))
		assert(false)
	#making camera/viewport changes after they're in the scene
	for each_num in number_of_players:
		_player_sub_viewports[player_viewport_names[each_num]].set_viewport_world(_world)
		_player_sub_viewports[player_viewport_names[each_num]].set_zoom(_player_view_zoom)
		_player_sub_viewports[player_viewport_names[each_num]].set_camera_limits(_camera_limits["Left"], _camera_limits["Top"], _camera_limits["Right"], _camera_limits["Bottom"])
		var player_culling_dictionary:Dictionary[int,bool] = {0:true, 1:false}
		_player_sub_viewports[player_viewport_names[each_num]].set_layers_visible(player_culling_dictionary)
		
func create_reticule(which_player:Player, tile_position:Vector2):
	var new_reticule:GridSprite = grid_sprite.instantiate()
	grid_man.add_child(new_reticule)
	player_reticules[which_player] = new_reticule
	new_reticule.set_sprite(load("res://art/reticule.png"))
	new_reticule.grid_coordinates = tile_position
	new_reticule.set_visual_position(Vector2(character_sprites[0].grid_coordinates.x * _tile_size.x, character_sprites[0].grid_coordinates.y * _tile_size.y))
		
func move_grid_sprite(which_sprite:GridSprite, tile_coord:Vector2, floor:int):
	if grid_man.is_directly_connected(floor, which_sprite.grid_coordinates, tile_coord) == false:
		return [Vector2(-INF,-INF), Vector2(-INF,-INF)]
	else:
		grid_man.floor_maps[floor][which_sprite.grid_coordinates.x][which_sprite.grid_coordinates.y].exit(0)
		grid_man.floor_maps[floor][tile_coord.x][tile_coord.y].enter(0)
		var new_sprite_tile_position:Vector2 = tile_coord
		var new_sprite_screen_position:Vector2 = tile_coord * _tile_size
		return [new_sprite_tile_position, new_sprite_screen_position]
		
#region testing methods
func _process(delta: float) -> void:
	for i in range(Config.MAX_PLAYER_COUNT):
		_handle_input(i)

func _handle_input(player_id: int):
	#if the player is not in reticule mode (where they just pan around to look at tiles) they move
	if player_reticules.has(testing_player) == false:
		if _input_managers[player_id].is_action_just_released("move_up"):
			var move_attempt_result = move_grid_sprite(character_sprites[player_id], Vector2(character_sprites[player_id].grid_coordinates.x, character_sprites[player_id].grid_coordinates.y - 1), 0)
			if move_attempt_result != [Vector2(-INF,-INF), Vector2(-INF,-INF)]:
				character_sprites[player_id].move(move_attempt_result[0], move_attempt_result[1])
		elif _input_managers[player_id].is_action_just_released("move_right"):
			var move_attempt_result = move_grid_sprite(character_sprites[player_id], Vector2(character_sprites[player_id].grid_coordinates.x + 1, character_sprites[player_id].grid_coordinates.y), 0)
			if move_attempt_result != [Vector2(-INF,-INF), Vector2(-INF,-INF)]:
				character_sprites[player_id].move(move_attempt_result[0], move_attempt_result[1])
		elif _input_managers[player_id].is_action_just_released("move_down"):
			var move_attempt_result = move_grid_sprite(character_sprites[player_id], Vector2(character_sprites[player_id].grid_coordinates.x, character_sprites[player_id].grid_coordinates.y + 1), 0)
			if move_attempt_result != [Vector2(-INF,-INF), Vector2(-INF,-INF)]:
				character_sprites[player_id].move(move_attempt_result[0], move_attempt_result[1])
		elif _input_managers[player_id].is_action_just_released("move_left"):
			var move_attempt_result = move_grid_sprite(character_sprites[player_id], Vector2(character_sprites[player_id].grid_coordinates.x - 1, character_sprites[player_id].grid_coordinates.y), 0)
			if move_attempt_result != [Vector2(-INF,-INF), Vector2(-INF,-INF)]:
				character_sprites[player_id].move(move_attempt_result[0], move_attempt_result[1])
		#elif _input_managers[player_id].is_action_just_released(Model.Action.TOGGLE_MAP):
			##testing switching to 'look around mode'
			#create_reticule(testing_player, character_sprites[player_id].grid_coordinates)
		#elif _input_managers[player_id].is_action_just_released(Model.Action.DESELECT):
			#create_reticule(testing_player, character_sprites[player_id].grid_coordinates)
			#grid_man.set_highlight_tiles(grid_man.get_reachable_tiles(0, character_sprites[player_id].grid_coordinates, 3), true, false)
	else: #if player is in reticule mode. only set up for p1 right now
		if _input_managers[player_id].is_action_just_released("move_up"):
			#check in bounds not currently doing anything here
			if grid_man.is_in_bounds(player_reticules[testing_player].grid_coordinates - Vector2(0,1)):
				player_reticules[testing_player].move(player_reticules[testing_player].grid_coordinates - Vector2(0,1), Vector2(0,-1 * _tile_size.y))
				_player_sub_viewports[player_id].move_camera(player_reticules[testing_player].grid_coordinates * _tile_size)
		elif _input_managers[player_id].is_action_just_released("move_right"):
			if grid_man.is_in_bounds(player_reticules[testing_player].grid_coordinates + Vector2(1,0)):
				player_reticules[testing_player].move(player_reticules[testing_player].grid_coordinates + Vector2(1,0), Vector2(_tile_size.x,0 ))
				_player_sub_viewports[player_id].move_camera(player_reticules[testing_player].grid_coordinates * _tile_size)
		elif _input_managers[player_id].is_action_just_released("move_down"):
			if grid_man.is_in_bounds(player_reticules[testing_player].grid_coordinates + Vector2(0,1)):
				player_reticules[testing_player].move(player_reticules[testing_player].grid_coordinates + Vector2(0,1), Vector2(0, _tile_size.y))
				_player_sub_viewports[player_id].move_camera(player_reticules[testing_player].grid_coordinates * _tile_size)
		elif _input_managers[player_id].is_action_just_released("move_left"):
			if grid_man.is_in_bounds(player_reticules[testing_player].grid_coordinates - Vector2(1,0)):
				player_reticules[testing_player].move(player_reticules[testing_player].grid_coordinates - Vector2(1,0), Vector2(-1 * _tile_size.x, 0))
				_player_sub_viewports[player_id].move_camera(player_reticules[testing_player].grid_coordinates * _tile_size)
		#elif _input_managers[player_id].is_action_just_released("debug_f"):
			##switching out of 'look around mode' back to character sprite control
			#grid_man.set_highlight_tiles(grid_man.get_reachable_tiles(0, character_sprites[player_id].grid_coordinates, 3), false, false)
			#player_reticules[testing_player].queue_free()
			#player_reticules.erase(testing_player)
			#_player_sub_viewports[player_id].move_camera(Vector2(character_sprites[player_id].grid_coordinates.x * _tile_size.x, character_sprites[player_id].grid_coordinates.y * _tile_size.y))

func setup_player_testing():
	player_to_character_sprite[testing_player] = character_sprites[0]
	var grid_man_origin = grid_man.global_position
	var player_viewport_names = [viewport_names.p1, viewport_names.p2, viewport_names.p3, viewport_names.p4]
	var test_player_coords:Array = [Vector2(1,1), Vector2(15,1), Vector2(6,14), Vector2(12,19)]
	for each_player in number_of_players:
		grid_man.testing_map_distance_algorithm(Vector2(test_player_coords[each_player]),3,0)
		character_sprites[each_player].grid_coordinates = test_player_coords[each_player]
		_player_sub_viewports[player_viewport_names[each_player]].visible = true
		character_sprites[each_player].set_visual_position(Vector2(test_player_coords[each_player].x * _tile_size.x, test_player_coords[each_player].y * _tile_size.y))
		character_sprites[each_player].set_remote_camera_transform(_player_sub_viewports[player_viewport_names[each_player]].camera)
		#_player_sub_viewports[player_viewport_names[each_player]].move_camera(grid_man_origin + Vector2(test_player_coords[each_player].x * _tile_size.x, test_player_coords[each_player].y * _tile_size.y))
		#_player_sub_viewports[player_viewport_names[each_player]].set_remote_camera_transform(character_sprites[each_player])
		character_sprites[each_player].moved.connect(grid_man._on_character_moved)
		character_sprites[each_player].set_minimap_sprite(load("res://art/character_minimap_icon.png"), Color("#f3e100"))
#endregion
		
#endregion
