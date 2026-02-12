class_name player_viewport extends Node

enum viewport_names{origin, minimap, p1, p2, p3, p4}

#region properties
var viewports:Dictionary[viewport_names, SubViewport]
var viewport_containers:Dictionary[viewport_names, SubViewportContainer]
var _cameras:Dictionary[viewport_names, Camera2D]
var _world:World2D
var grid_man:grid_manager
var _viewport_organizer_vertical:VBoxContainer
var _viewport_organizer_top_horizontal:HBoxContainer
var _viewport_organizer_bottom_horizontal:HBoxContainer
var _minimap_zoom:Vector2 = Vector2(0.2,0.2)
var _minimap_size:Vector2 #= Vector2(200,200)
var _player_view_zoom:Vector2 = Vector2(1.3,1.3)
var _minimap_coord_1p:Vector2# = Vector2(DisplayServer.window_get_size().x - _minimap_size.x/2, 0)
var _minimap_coord_2p:Vector2# = Vector2(DisplayServer.window_get_size().x - _minimap_size.x/2, (DisplayServer.window_get_size().y / 2) - _minimap_size.y/2)
var _minimap_coord_4p:Vector2# = Vector2((DisplayServer.window_get_size().x / 2) - _minimap_size.x/2, (DisplayServer.window_get_size().y / 2) - _minimap_size.y/2)
var _camera_limits:Dictionary[String,int]
var _testing_tile_size:Vector2 = Vector2(60,60)
#endregion

#region methods
func _ready() -> void:
	#$SubViewportContainer.size = DisplayServer.window_get_size()
	_viewport_organizer_vertical = $VertViewportOrganizer
	_viewport_organizer_top_horizontal = $VertViewportOrganizer/TopHorViewportOrganizer
	_viewport_organizer_bottom_horizontal = $VertViewportOrganizer/BotHorViewportOrganizer
	viewports[viewport_names.origin] = $OriginViewportContainer/OriginViewport
	viewports[viewport_names.minimap] = $MinimapViewportContainer/MinimapViewport
	viewports[viewport_names.p1] = $P1ViewportContainer/P1Viewport
	viewports[viewport_names.p2] = $P2ViewportContainer/P2Viewport
	viewports[viewport_names.p3] = $P3ViewportContainer/P3Viewport
	viewports[viewport_names.p4] = $P4ViewportContainer/P4Viewport
	viewport_containers[viewport_names.origin] = $OriginViewportContainer
	viewport_containers[viewport_names.minimap] = $MinimapViewportContainer
	viewport_containers[viewport_names.p1] = $P1ViewportContainer
	viewport_containers[viewport_names.p2] = $P2ViewportContainer
	viewport_containers[viewport_names.p3] = $P3ViewportContainer
	viewport_containers[viewport_names.p4] = $P4ViewportContainer
	_camera_limits["Left"] = 0
	_camera_limits["Top"] = 0
	_camera_limits["Right"] = 1000
	_camera_limits["Bottom"] = 1000
	_cameras[viewport_names.minimap] = $MinimapViewportContainer/MinimapViewport/MinimapCamera
	_cameras[viewport_names.p1] = $P1ViewportContainer/P1Viewport/P1Camera
	_cameras[viewport_names.p2] = $P2ViewportContainer/P2Viewport/P2Camera
	_cameras[viewport_names.p3] = $P3ViewportContainer/P3Viewport/P3Camera
	_cameras[viewport_names.p4] = $P4ViewportContainer/P4Viewport/P4Camera
	for each_camera in _cameras:
		_cameras[each_camera].limit_left = _camera_limits["Left"]
		_cameras[each_camera].limit_top = _camera_limits["Top"]
		_cameras[each_camera].limit_right = _camera_limits["Right"]
		_cameras[each_camera].limit_bottom = _camera_limits["Bottom"]
	grid_man = $OriginViewportContainer/OriginViewport/GridManager
	grid_man.generate_map(0)
	_minimap_size = Vector2(((grid_man.map_width * _testing_tile_size.x) * _minimap_zoom.x), ((grid_man.map_height * _testing_tile_size.y) * _minimap_zoom.y))
	_minimap_coord_1p = Vector2(DisplayServer.window_get_size().x - _minimap_size.x/2, 0)
	_minimap_coord_2p = Vector2(DisplayServer.window_get_size().x - _minimap_size.x/2, (DisplayServer.window_get_size().y / 2) - _minimap_size.y/2)
	_minimap_coord_4p = Vector2((DisplayServer.window_get_size().x / 2) - _minimap_size.x/2, (DisplayServer.window_get_size().y / 2) - _minimap_size.y/2)
	setup_viewports([0,1,2,3])

func setup_viewports(players:Array):
	#viewport_containers[viewport_names.origin].size = Vector2(((grid_man.map_width * _testing_tile_size.x) * _minimap_zoom.x), ((grid_man.map_height * _testing_tile_size.y) * _minimap_zoom.y))
	_world = viewports[viewport_names.origin].find_world_2d()
	viewports[viewport_names.minimap].world_2d = _world
	viewports[viewport_names.p1].world_2d = _world
	viewports[viewport_names.p2].world_2d = _world
	viewports[viewport_names.p3].world_2d = _world
	viewports[viewport_names.p4].world_2d = _world
	viewports[viewport_names.minimap].world_2d = _world
	viewport_containers[viewport_names.minimap].visible = true
	viewport_containers[viewport_names.minimap].size = _minimap_size
	_cameras[viewport_names.minimap].zoom = Vector2(_minimap_zoom)
	_cameras[viewport_names.p1].zoom = Vector2(_player_view_zoom)
	_cameras[viewport_names.p2].zoom = Vector2(_player_view_zoom)
	_cameras[viewport_names.p3].zoom = Vector2(_player_view_zoom)
	_cameras[viewport_names.p4].zoom = Vector2(_player_view_zoom)
	##adding viewports to the containers and making containers visible
	for each_num in players.size():
		var viewport_names_to_activate = [viewport_names.p1, viewport_names.p2, viewport_names.p3, viewport_names.p4]
		remove_child(viewport_containers[viewport_names_to_activate[each_num]])
		viewport_containers[viewport_names_to_activate[each_num]].visible = true
	if players.size() == 1:
		_viewport_organizer_vertical.visible = true
		_viewport_organizer_vertical.add_child(viewport_containers[viewport_names.p1])
		viewport_containers[viewport_names.minimap].global_position = _minimap_coord_1p
	elif players.size() == 2:
		_viewport_organizer_vertical.visible = true
		_viewport_organizer_top_horizontal.visible = true
		_viewport_organizer_bottom_horizontal.visible = true
		_viewport_organizer_top_horizontal.add_child(viewport_containers[viewport_names.p1])
		_viewport_organizer_bottom_horizontal.add_child(viewport_containers[viewport_names.p2])
		viewport_containers[viewport_names.minimap].global_position = _minimap_coord_2p
	elif players.size() == 3:
		remove_child(viewport_containers[viewport_names.minimap])
		_viewport_organizer_vertical.visible = true
		_viewport_organizer_top_horizontal.visible = true
		_viewport_organizer_bottom_horizontal.visible = true
		_viewport_organizer_top_horizontal.add_child(viewport_containers[viewport_names.p1])
		_viewport_organizer_bottom_horizontal.add_child(viewport_containers[viewport_names.p2])
		_viewport_organizer_bottom_horizontal.add_child(viewport_containers[viewport_names.p3])
		_viewport_organizer_top_horizontal.add_child(viewport_containers[viewport_names.minimap])
	elif players.size() == 4:
		_viewport_organizer_vertical.visible = true
		_viewport_organizer_top_horizontal.visible = true
		_viewport_organizer_bottom_horizontal.visible = true
		_viewport_organizer_top_horizontal.add_child(viewport_containers[viewport_names.p1])
		_viewport_organizer_bottom_horizontal.add_child(viewport_containers[viewport_names.p2])
		_viewport_organizer_bottom_horizontal.add_child(viewport_containers[viewport_names.p3])
		_viewport_organizer_top_horizontal.add_child(viewport_containers[viewport_names.p4])
		viewport_containers[viewport_names.minimap].global_position = _minimap_coord_4p
	else:
		print("invalid number of players:" + str(players.size()))
		assert(false)
	var grid_man_origin = grid_man.global_position
	var test_players = [$OriginViewportContainer/OriginViewport/Player1, $OriginViewportContainer/OriginViewport/Player2, $OriginViewportContainer/OriginViewport/Player3, $OriginViewportContainer/OriginViewport/Player4]
	for each_player in players:
		var player_viewports = [viewport_names.p1, viewport_names.p2, viewport_names.p3, viewport_names.p4]
		var test_player_coords:Array = [Vector2(1,1), Vector2(15,5), Vector2(6,14), Vector2(12,18)]
		var tile_size = _testing_tile_size
		grid_man.testing_map_distance_algorithm(Vector2(test_player_coords[each_player]),3,0)
		test_players[each_player].visible = true
		test_players[each_player].position = grid_man_origin + Vector2(test_player_coords[each_player].x * tile_size.x, test_player_coords[each_player].y * tile_size.y)
		_cameras[player_viewports[each_player]].position = grid_man_origin + Vector2(test_player_coords[each_player].x * tile_size.x, test_player_coords[each_player].y * tile_size.y)
		
#endregion
