extends Control

@export var card_manager: CardManager
@export var deck: Deck

var start_pos := Vector2.ZERO
var end_pos := Vector2.ZERO
var mouse_is_pressed := false

var card_scene := preload("res://cards/card.tscn")


func _ready() -> void:
	card_manager.deck = deck
	

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("debug_up"):
		var card: Card = card_scene.instantiate()
		deck.add_card(card)
	if Input.is_action_just_pressed("debug_v"):
		deck.toggle_display()
	if deck.count > 0 and Input.is_action_just_pressed("debug_down"):
		var card: Card = deck.cards[0]
		deck.remove_card(card)
		card.queue_free()
	
	


#func _gui_input(event: InputEvent) -> void:
	#if event is InputEventMouseButton:
		#var button_event := event as InputEventMouseButton
		#if button_event.pressed and not mouse_is_pressed:
			#mouse_is_pressed = true
			#start_pos = get_global_mouse_position()
			#print("start: ", start_pos)
		#elif not button_event.pressed and mouse_is_pressed:
			#mouse_is_pressed = false
			#end_pos = get_global_mouse_position()
			#print("end: ", end_pos)
