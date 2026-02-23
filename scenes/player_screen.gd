class_name PlayerScreen
extends Control


@export var player_sub_viewport: PlayerSubViewport
@export var card_manager: CardManager

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


func _setup_card_area() -> void:
	## Set up card area
	var deck = deck_scene.instantiate()
	add_child(deck)
	card_manager.set_deck(deck)
	
	
func _setup_player_viewport() -> void:
	var player_culling_dictionary:Dictionary[int,bool] = {0:true, 1:false}
	var camera_limits = origin_viewport._camera_limits
	
	player_sub_viewport.set_viewport_world(origin_viewport._world)
	player_sub_viewport.set_zoom(_player_view_zoom)
	player_sub_viewport.set_camera_limits(camera_limits["Left"], camera_limits["Top"], camera_limits["Right"], camera_limits["Bottom"])
	player_sub_viewport.set_layers_visible(player_culling_dictionary)
