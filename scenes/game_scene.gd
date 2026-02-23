extends Node2D


@export var player_areas: Array[Control]
@export var origin_viewport: OriginViewport
@export var _player_view_zoom:Vector2 = Vector2(1.6,1.6)

@onready var player_screen_scene := preload("res://scenes/player_screen.tscn")
@onready var player_viewport_scene := preload("res://scenes/player_subviewport.tscn")
@onready var card_manager_scene: PackedScene = preload("res://cards/card_manager.tscn")
@onready var deck_scene := preload("res://cards/Deck.tscn")
@onready var character_sprite_scene := preload("res://entities/character_sprite.tscn")

#region Built-in methods
func _ready() -> void:
	for i in player_areas.size():
		var player_screen: PlayerScreen = player_screen_scene.instantiate()
		player_screen.origin_viewport = origin_viewport
		player_areas[i].add_child(player_screen)
		
		var character_sprite := origin_viewport.add_character()
		character_sprite.set_remote_camera_transform(player_screen.player_sub_viewport.camera)
#endregion
