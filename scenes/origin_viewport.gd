class_name PlayerViewport extends Node

enum viewport_names{origin, minimap, p1, p2, p3, p4}

#region properties
@onready var character_sprite = preload("res://entities/character_sprite.tscn")
@onready var player_viewport = preload("res://scenes/player_subviewport.tscn")
var _player_sub_viewports:Dictionary[viewport_names, PlayerSubViewport]
@onready var _world:World2D = $OriginViewportContainer/OriginViewport.find_world_2d()
@onready var grid_man:GridManager = $OriginViewportContainer/OriginViewport/GridManager
var _viewport_organizer_vertical:VBoxContainer
var _viewport_organizer_top_horizontal:HBoxContainer
var _viewport_organizer_bottom_horizontal:HBoxContainer
@onready var _minimap_zoom:Vector2 = Vector2(0.2,0.2)
@onready var _minimap_size:Vector2 = Vector2(200,200)
var _player_view_zoom:Vector2 = Vector2(1.3,1.3)
var _minimap_coord_1p:Vector2
var _minimap_coord_2p:Vector2
var _minimap_coord_4p:Vector2
var _camera_limits:Dictionary[String,int]
@onready var _testing_tile_size:Vector2 = Vector2(60,60)
@onready var _player_viewport_size:Vector2# = Vector2(100,100)#Vector2(DisplayServer.window_get_size().x / 2,DisplayServer.window_get_size().y / 2)
var number_of_players:int
var character_sprites:Array
#endregion

#region methods
func _ready() -> void:
	#moving origin viewport container and its children out of the regular viewable screen space so it doesn't peek through
	$OriginViewportContainer.position.y = -1 * (grid_man.map_height * _testing_tile_size.y)
	_viewport_organizer_vertical = $VertViewportOrganizer
	_viewport_organizer_top_horizontal = $VertViewportOrganizer/TopHorViewportOrganizer
	_viewport_organizer_bottom_horizontal = $VertViewportOrganizer/BotHorViewportOrganizer
	#_viewport_organizer_vertical.custom_minimum_size = DisplayServer.window_get_size()
	_camera_limits["Left"] = 0
	_camera_limits["Top"] = 0
	_camera_limits["Right"] = (grid_man.map_width * _testing_tile_size.x)
	_camera_limits["Bottom"] = (grid_man.map_height * _testing_tile_size.y)
	_minimap_size = Vector2(((grid_man.map_width * _testing_tile_size.x) * _minimap_zoom.x), ((grid_man.map_height * _testing_tile_size.y) * _minimap_zoom.y))
	_minimap_coord_1p = Vector2(DisplayServer.window_get_size().x - _minimap_size.x, 0)
	_minimap_coord_2p = Vector2(DisplayServer.window_get_size().x - _minimap_size.x, (DisplayServer.window_get_size().y / 2) - _minimap_size.y/2)
	_minimap_coord_4p = Vector2((DisplayServer.window_get_size().x / 2) - _minimap_size.x/2, (DisplayServer.window_get_size().y / 2) - _minimap_size.y/2)
	setup_viewports([0,1,2,3])
	setup_player_testing()

func setup_viewports(players:Array):
	number_of_players = 2
	#1 player drawing minimap off side
	#2 players drawing minimap off side
	#3 minimap sizing + placement
	#viewport_containers[viewport_names.origin].size = Vector2(((grid_man.map_width * _testing_tile_size.x) * _minimap_zoom.x), ((grid_man.map_height * _testing_tile_size.y) * _minimap_zoom.y))
	#setting up the minimap viewport
	var minimap_viewport = player_viewport.instantiate()
	add_child(minimap_viewport)
	minimap_viewport.set_viewport_world(_world)
	minimap_viewport.set_bounds(_minimap_size)
	minimap_viewport.set_zoom(_minimap_zoom)
	minimap_viewport.toggle_background()
	minimap_viewport.set_fade(0.7)
	var minimap_camera_center_position = Vector2((grid_man.map_width * _testing_tile_size.x) / 2, ( (grid_man.map_height * _testing_tile_size.y)) / 2)
	minimap_viewport.move_camera(minimap_camera_center_position)
	_player_sub_viewports[viewport_names.minimap] = minimap_viewport
	##adding viewports to the containers and making containers visible
	var player_viewport_names = [viewport_names.p1, viewport_names.p2, viewport_names.p3, viewport_names.p4]
	for each_num in number_of_players:
		var new_player_viewport = player_viewport.instantiate()
		_player_sub_viewports[player_viewport_names[each_num]] = new_player_viewport
		var new_character_sprite = character_sprite.instantiate()
		new_character_sprite.set_sprite()
		grid_man.add_child(new_character_sprite)
		character_sprites.append(new_character_sprite)
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
		_player_sub_viewports[viewport_names.minimap].toggle_background()
		#_viewport_organizer_top_horizontal.add_child(_player_sub_viewports[viewport_names.minimap])
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
		#_player_sub_viewports[player_viewport_names[each_num]].set_bounds(_player_viewport_size)
		_player_sub_viewports[player_viewport_names[each_num]].set_viewport_world(_world)
		_player_sub_viewports[player_viewport_names[each_num]].set_zoom(_player_view_zoom)
		_player_sub_viewports[player_viewport_names[each_num]].set_camera_limits(_camera_limits["Left"], _camera_limits["Top"], _camera_limits["Right"], _camera_limits["Bottom"])
	#_viewport_organizer_vertical.reset_size()
	#_viewport_organizer_top_horizontal.reset_size()
	#_viewport_organizer_bottom_horizontal.reset_size()
		
#region testing methods

func setup_player_testing():
	var grid_man_origin = grid_man.global_position
	var player_viewport_names = [viewport_names.p1, viewport_names.p2, viewport_names.p3, viewport_names.p4]
	var test_player_coords:Array = [Vector2(1,1), Vector2(15,1), Vector2(6,14), Vector2(12,19)]
	var tile_size = _testing_tile_size
	for each_player in number_of_players:
		grid_man.testing_map_distance_algorithm(Vector2(test_player_coords[each_player]),3,0)
		_player_sub_viewports[player_viewport_names[each_player]].visible = true
		character_sprites[each_player].set_visual_position(Vector2(test_player_coords[each_player].x * tile_size.x, test_player_coords[each_player].y * tile_size.y))
		_player_sub_viewports[player_viewport_names[each_player]].move_camera(grid_man_origin + Vector2(test_player_coords[each_player].x * tile_size.x, test_player_coords[each_player].y * tile_size.y))
#endregion
		
#endregion
