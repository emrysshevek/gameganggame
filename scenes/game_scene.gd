extends Node2D

enum viewport_names{p1, p2, p3, p4, origin, minimap}

@export var player_areas: Array[Control]
@export var origin_viewport: OriginViewport
@export var _player_view_zoom:Vector2 = Vector2(1.6,1.6)


@onready var player_screen_scene := preload("res://scenes/player_screen.tscn")
@onready var player_viewport_scene := preload("res://scenes/player_subviewport.tscn")
@onready var card_manager_scene: PackedScene = preload("res://cards/card_manager.tscn")
@onready var deck_scene := preload("res://cards/Deck.tscn")
@onready var character_sprite_scene := preload("res://entities/character_sprite.tscn")
@onready var pism_scene := preload("res://input/state_machine/PlayerInputStateMachine.tscn")
@onready var _minimap_zoom:Vector2 = Vector2(0.2,0.2)
@onready var _minimap_size:Vector2 = Vector2(200,200)
@onready var grid_man:GridManager = $OriginViewportController/OriginViewportContainer/OriginViewport/GridManager

var _player_sub_viewports:Dictionary[viewport_names, PlayerSubViewport]
var _tile_size:Vector2
var number_of_players:int
var _minimap_coord_1p:Vector2
var _minimap_coord_2p:Vector2
var _minimap_coord_3p:Vector2
var _minimap_coord_4p:Vector2

#region Built-in methods
func _ready() -> void:
	_tile_size = grid_man.tile_size
	setup_players()
	setup_minimap()
#endregion


#region Private Methods
func setup_players() -> void:
	for i in player_areas.size():
		var player_input_manager := InputManager.get_player_input_manager(i)
		var pis_machine: PlayerInputStateMachine = pism_scene.instantiate()
		var player_screen: PlayerScreen = player_screen_scene.instantiate()
		var character_sprite := origin_viewport.add_character(i) #i should be character id in this case
		var new_cursor := origin_viewport.create_cursor(i,character_sprite.grid_coordinates)
		
		# pis machine setup
		pis_machine.character_sprite = character_sprite
		add_child(pis_machine)
		
		# player screen setup
		player_screen.card_manager.input_man = player_input_manager
		player_screen.card_manager.input_state_machine = pis_machine
		player_screen.origin_viewport = origin_viewport
		player_areas[i].add_child(player_screen)
		
		# character setup
		character_sprite.input_man = player_input_manager
		character_sprite.input_state_machine = pis_machine
		character_sprite.set_remote_camera_transform(player_screen.player_sub_viewport.camera)
		
		# cursor setup
		new_cursor.input_man = player_input_manager
		new_cursor.input_state_machine = pis_machine
		
		pass
		
#endregion


#region Private Methods
func setup_minimap():
	_minimap_size = Vector2(((grid_man.map_width * _tile_size.x) * _minimap_zoom.x), ((grid_man.map_height * _tile_size.y) * _minimap_zoom.y))
	_minimap_coord_1p = Vector2(DisplayServer.window_get_size().x - _minimap_size.x, 0)
	_minimap_coord_2p = Vector2(DisplayServer.window_get_size().x - _minimap_size.x, (DisplayServer.window_get_size().y / 2) - _minimap_size.y/2)
	_minimap_coord_3p = Vector2((DisplayServer.window_get_size().x / 2) + _minimap_size.x/2, (DisplayServer.window_get_size().y / 2) - _minimap_size.y)
	_minimap_coord_4p = Vector2((DisplayServer.window_get_size().x / 2) - _minimap_size.x/2, (DisplayServer.window_get_size().y / 2) - _minimap_size.y/2)
	number_of_players = 4 #testing for easy config of # of players
	#setting up the minimap viewport
	var minimap_coords = [_minimap_coord_1p, _minimap_coord_2p, _minimap_coord_3p, _minimap_coord_4p]
	var minimap_viewport = player_viewport_scene.instantiate()
	add_child(minimap_viewport)
	minimap_viewport.set_viewport_world(origin_viewport._world)
	minimap_viewport.set_bounds(_minimap_size)
	minimap_viewport.set_zoom(_minimap_zoom)
	minimap_viewport.toggle_background()
	minimap_viewport.set_fade(0.8)
	minimap_viewport.set_stretch(false)
	minimap_viewport.position = minimap_coords[number_of_players - 1]
	var culling_dictionary:Dictionary[int,bool] = {0:true, 1:true}
	minimap_viewport.set_layers_visible(culling_dictionary)
	var minimap_camera_center_position = Vector2((grid_man.map_width * _tile_size.x) / 2, ( (grid_man.map_height * _tile_size.y)) / 2)
	minimap_viewport.move_camera(minimap_camera_center_position)
	_player_sub_viewports[viewport_names.minimap] = minimap_viewport
	minimap_viewport.reparent($PlayerAreas/Control)

	
func _on_card_play_request(which_player, card):
	pass
#endregion

#region testing methods
func _testing_card_activate_effect(which_card:Card):
	$OriginViewportController.player_id_to_character_sprite[which_card.owning_character_id].movement = 3
#endregion
