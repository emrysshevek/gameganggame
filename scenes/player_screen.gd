class_name PlayerScreen
extends Control


@export var player_sub_viewport: PlayerSubViewport
@export var card_manager: CardManager
@export var turn_ended_overlay: ColorRect

@export var player_id: int
@export var origin_viewport: OriginViewport
@export var _player_view_zoom:Vector2 = Vector2(1.6,1.6)

# scenes
@onready var player_screen_scene := preload("res://scenes/player_screen.tscn")
@onready var player_viewport_scene := preload("res://scenes/player_subviewport.tscn")
@onready var card_manager_scene: PackedScene = preload("res://cards/card_manager.tscn")
@onready var deck_scene := preload("res://cards/Deck.tscn")
@onready var character_sprite_scene := preload("res://entities/character_sprite.tscn")


func _ready() -> void:
	_setup_player_viewport()
	_setup_card_area()
	turn_ended_overlay.hide()
	
	Events.round_started.connect(_on_round_started)
	Events.player_turn_ended.connect(_on_player_turn_ended)
	
	
func start_turn() -> void:
	card_manager.turn_start_draw()
	
	
func end_turn() -> void:
	for card in card_manager.hand_pile.cards:
		card_manager.discard(card)
	
	
func toggle_turn_ended() -> void:
	turn_ended_overlay.visible = !turn_ended_overlay.visible


func _setup_card_area() -> void:
	## Set up card area
	var deck = deck_scene.instantiate()
	add_child(deck)
	card_manager.set_deck(deck)
	card_manager.set_input_man(InputManager.get_player_input_manager(player_id))
	
	
func _setup_player_viewport() -> void:
	var this_player_only_culling_layer = Model.CullingLayers.values()[2 + player_id]
	var player_culling_dictionary:Dictionary[Model.CullingLayers,bool] = {
		Model.CullingLayers.VISIBLE_ALL:true, 
		Model.CullingLayers.VISIBLE_MINIMAP_ONLY:false,
		Model.CullingLayers.VISIBLE_P1_ONLY:false,
		Model.CullingLayers.VISIBLE_P2_ONLY:false,
		Model.CullingLayers.VISIBLE_P3_ONLY:false,
		Model.CullingLayers.VISIBLE_P4_ONLY:false,
	}
	player_culling_dictionary[this_player_only_culling_layer] = true
	var camera_limits = origin_viewport._camera_limits
	
	player_sub_viewport.set_viewport_world(origin_viewport._world)
	player_sub_viewport.set_zoom(_player_view_zoom)
	player_sub_viewport.set_camera_limits(camera_limits["Left"], camera_limits["Top"], camera_limits["Right"], camera_limits["Bottom"])
	player_sub_viewport.set_layers_visible(player_culling_dictionary)
	

func _on_round_started() -> void:
	turn_ended_overlay.hide()
	

func _on_player_turn_ended(_character: Character) -> void:
	if _character.character_id == player_id:
		turn_ended_overlay.show()
	
