extends Node2D


@export var player_areas: Array[Control]

@onready var card_manager_scene: PackedScene = preload("res://cards/card_manager.tscn")
@onready var deck_scene := preload("res://cards/deck.tscn")

func _ready() -> void:
	for area in player_areas:
		var deck = deck_scene.instantiate()
		area.add_child(deck)
		
		var card_manager: CardManager = card_manager_scene.instantiate()
		card_manager.deck = deck
		area.add_child(card_manager)
		
	
