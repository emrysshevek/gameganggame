class_name GameScene
extends Node2D

enum viewport_names{p1, p2, p3, p4, origin, minimap}

@export var player_areas: Array[Control]
@export var origin_viewport: OriginViewport
@export var _player_view_zoom:Vector2 = Vector2(1.6,1.6)
@export var manual_set_number_of_players:int = 1

@export var card_list: CardList

var characters: Array[Character] = []

@onready var notification_log_scene := preload("res://components/notification_log.tscn")
@onready var player_screen_scene := preload("res://scenes/player_screen.tscn")
@onready var player_viewport_scene := preload("res://scenes/player_subviewport.tscn")
@onready var card_manager_scene: PackedScene = preload("res://cards/card_manager.tscn")
@onready var deck_scene := preload("res://cards/Deck.tscn")
@onready var character_sprite_scene := preload("res://entities/character_sprite.tscn")
@onready var pism_scene := preload("res://input/state_machine/PlayerInputStateMachine.tscn")
@onready var card_scene :=preload("res://cards/card.tscn")
@onready var _minimap_zoom:Vector2 = Vector2(0.2,0.2)
@onready var _minimap_size:Vector2 = Vector2(200,200)
@onready var grid_man:GridManager = $OriginViewportController/OriginViewportContainer/OriginViewport/GridManager


var _player_sub_viewports:Dictionary[viewport_names, PlayerSubViewport]
var _tile_size:Vector2
var _minimap_coord_1p:Vector2
var _minimap_coord_2p:Vector2
var _minimap_coord_3p:Vector2
var _minimap_coord_4p:Vector2

#region Built-in methods
func _ready() -> void:
	_tile_size = grid_man.tile_size
	setup_players()
	var minimap:PlayerSubViewport = setup_minimap()
	minimap.reparent($PlayerAreas/Control)
	var notif_log = notification_log_scene.instantiate()
	$PlayerAreas/Control.add_child(notif_log)
	notif_log.position = Vector2(minimap.position.x, minimap.position.y + _minimap_size.y)
#endregion


#region Private Methods
func setup_players() -> void:
	for i in manual_set_number_of_players:
		var new_player_area:Control = Control.new()
		new_player_area.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		player_areas.append(new_player_area)
		if i > 1:
			$PlayerAreas/Control/VBoxContainer/BotRow.visible = true
		if i == 0 || i == 1:
			$PlayerAreas/Control/VBoxContainer/TopRow.add_child(new_player_area)
		else:
			$PlayerAreas/Control/VBoxContainer/BotRow.add_child(new_player_area)
		var new_character = Character.new()
		var player_input_manager := InputManager.get_player_input_manager(i)
		var pis_machine: PlayerInputStateMachine = pism_scene.instantiate()
		
		new_character.setup_new_character(i, pis_machine)
		characters.append(new_character)
		##deck setup
		var new_deck = deck_scene.instantiate()
		new_character.bind_deck(new_deck)
		for card_scene in card_list.cards.values():
			var new_card = card_scene.instantiate()
			new_card.owning_character = new_character
			new_deck.add_card(new_card)
		##
		new_character.bind_pis_machine(pis_machine)
		origin_viewport.add_character(new_character) #i should be character id in this case
		var player_screen: PlayerScreen = player_screen_scene.instantiate()
		player_screen.card_manager.deck = new_deck
		
		# pis machine setup
		pis_machine.character = new_character
		add_child(pis_machine)
		pis_machine.owner = self
		
		# player screen setup
		player_screen.card_manager.input_man = player_input_manager
		player_screen.card_manager.input_state_machine = pis_machine
		player_screen.origin_viewport = origin_viewport
		player_screen.player_id = i
		player_areas[i].add_child(player_screen)
		
		# character setup
		new_character.bind_screen(player_screen)
		new_character.character_sprite.set_remote_camera_transform(player_screen.player_sub_viewport.camera)
		
		# cursor setup
		#new_cursor.input_man = player_input_manager
		#new_cursor.input_state_machine = pis_machine
		
		pass
		
#endregion

func setup_minimap():
	_minimap_size = Vector2(((grid_man.map_width * _tile_size.x) * _minimap_zoom.x), ((grid_man.map_height * _tile_size.y) * _minimap_zoom.y))
	_minimap_coord_1p = Vector2(DisplayServer.window_get_size().x - _minimap_size.x, 0)
	_minimap_coord_2p = Vector2((DisplayServer.window_get_size().x / 2) - _minimap_size.x/2, (DisplayServer.window_get_size().y) - _minimap_size.y)
	_minimap_coord_3p = Vector2((0), (DisplayServer.window_get_size().y) - _minimap_size.y)
	_minimap_coord_4p = Vector2((DisplayServer.window_get_size().x / 2) - _minimap_size.x/2, (DisplayServer.window_get_size().y / 2) - _minimap_size.y/2)
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
	minimap_viewport.position = minimap_coords[player_areas.size() - 1]
	var culling_dictionary:Dictionary[Model.CullingLayers,bool] = {
		Model.CullingLayers.VISIBLE_ALL:true, 
		Model.CullingLayers.VISIBLE_MINIMAP_ONLY:true,
		Model.CullingLayers.VISIBLE_P1_ONLY:false,
		Model.CullingLayers.VISIBLE_P2_ONLY:false,
		Model.CullingLayers.VISIBLE_P3_ONLY:false,
		Model.CullingLayers.VISIBLE_P4_ONLY:false,
	}
	minimap_viewport.set_layers_visible(culling_dictionary)
	var minimap_camera_center_position = Vector2((grid_man.map_width * _tile_size.x) / 2, ( (grid_man.map_height * _tile_size.y)) / 2)
	minimap_viewport.move_camera(minimap_camera_center_position)
	_player_sub_viewports[viewport_names.minimap] = minimap_viewport
	return minimap_viewport	

	
func _on_card_play_request(which_player, card):
	pass
#endregion
