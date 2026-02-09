class_name Card
extends Control


#region Signals
signal card_played(which_card)
signal card_discarded(which_card)
signal card_flipped(which_card)
#endregion


#region Properties
@export var cost: Dictionary
@export var description: String = "Placeholder Description"
@export var deck: Deck = null
var is_faceup: bool = true

@onready var backside: Node = $Back
@onready var frontside: Node = $Front
@onready var description_label: Label = $Front/MarginContainer/VBoxContainer/Description
@onready var costs_hbox: HBoxContainer = $Front/MarginContainer/VBoxContainer/Costs
#endregion


#region Godot Built-in Methods
func _ready() -> void:
	description_label.text = description
	if is_faceup:
		frontside.show()
		backside.hide()
	else:
		frontside.hide()
		backside.show()
#endregion


#region Public Methods
func flip() -> void:
	if is_faceup:
		frontside.hide()
		backside.show()
	else:
		frontside.show()
		backside.hide()
	is_faceup = !is_faceup
	
func play() -> void:
	card_played.emit(self)
	
func discard() -> void:
	card_discarded.emit(self)
#endregion


func _on_button_pressed() -> void:
	flip()
