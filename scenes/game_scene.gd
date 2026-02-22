extends Node2D

enum viewport_names{p1, p2, p3, p4, origin, minimap}

@export var player_areas: Array[Control]
@export var origin_viewport: OriginViewport
@export var _player_view_zoom:Vector2 = Vector2(1.6,1.6)

@onready var card_manager_scene: PackedScene = preload("res://cards/card_manager.tscn")
@onready var deck_scene := preload("res://cards/deck.tscn")
@onready var player_viewport_scene := preload("res://scenes/player_subviewport.tscn")
@onready var character_sprite_scene := preload("res://entities/character_sprite.tscn")
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
	_minimap_size = Vector2(((grid_man.map_width * _tile_size.x) * _minimap_zoom.x), ((grid_man.map_height * _tile_size.y) * _minimap_zoom.y))
	_minimap_coord_1p = Vector2(DisplayServer.window_get_size().x - _minimap_size.x, 0)
	_minimap_coord_2p = Vector2(DisplayServer.window_get_size().x - _minimap_size.x, (DisplayServer.window_get_size().y / 2) - _minimap_size.y/2)
	_minimap_coord_3p = Vector2((DisplayServer.window_get_size().x / 2) + _minimap_size.x/2, (DisplayServer.window_get_size().y / 2) - _minimap_size.y)
	_minimap_coord_4p = Vector2((DisplayServer.window_get_size().x / 2) - _minimap_size.x/2, (DisplayServer.window_get_size().y / 2) - _minimap_size.y/2)
	for i in player_areas.size():
		var player_viewport = _setup_player_viewport(player_areas[i])
		var character_sprite := origin_viewport.add_character(i) #i should be character id in this case
		character_sprite.set_remote_camera_transform(player_viewport.camera)
		var card_manager := _setup_card_area(player_areas[i])
	setup_minimap().reparent($PlayerAreas/Control)
#endregion


#region Private Methods
func _setup_card_area(area: Node) -> CardManager:
	## Set up card area
	var deck = deck_scene.instantiate()
	area.add_child(deck)
	
	var card_manager: CardManager = card_manager_scene.instantiate()
	card_manager.deck = deck
	card_manager.card_play_request.connect(_on_card_play_request)
	area.add_child(card_manager)
	
	return card_manager

func setup_minimap():
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
	return minimap_viewport	
	
func _setup_player_viewport(area: Node) -> PlayerSubViewport:
	var player_culling_dictionary:Dictionary[int,bool] = {0:true, 1:false}
	var camera_limits = origin_viewport._camera_limits
	## Set up player sub viewport
	var player_viewport: PlayerSubViewport = player_viewport_scene.instantiate()
	area.add_child(player_viewport)
	
	player_viewport.set_viewport_world(origin_viewport._world)
	player_viewport.set_zoom(_player_view_zoom)
	player_viewport.set_camera_limits(camera_limits["Left"], camera_limits["Top"], camera_limits["Right"], camera_limits["Bottom"])
	player_viewport.set_layers_visible(player_culling_dictionary)
	
	return player_viewport
	
func _on_card_play_request(which_player, card):
	pass
#endregion
