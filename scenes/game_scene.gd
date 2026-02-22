extends Node2D


@export var player_areas: Array[Control]
@export var origin_viewport: OriginViewport
@export var _player_view_zoom:Vector2 = Vector2(1.6,1.6)

@onready var card_manager_scene: PackedScene = preload("res://cards/card_manager.tscn")
@onready var deck_scene := preload("res://cards/deck.tscn")
@onready var player_viewport_scene := preload("res://scenes/player_subviewport.tscn")
@onready var character_sprite_scene := preload("res://entities/character_sprite.tscn")

#region Built-in methods
func _ready() -> void:
	for i in player_areas.size():
		var player_viewport = _setup_player_viewport(player_areas[i])
		var character_sprite := origin_viewport.add_character()
		character_sprite.set_remote_camera_transform(player_viewport.camera)
		var card_manager := _setup_card_area(player_areas[i])
#endregion


#region Private Methods
func _setup_card_area(area: Node) -> CardManager:
	## Set up card area
	var deck = deck_scene.instantiate()
	area.add_child(deck)
	
	var card_manager: CardManager = card_manager_scene.instantiate()
	card_manager.deck = deck
	area.add_child(card_manager)
	
	return card_manager
	
	
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
#endregion
