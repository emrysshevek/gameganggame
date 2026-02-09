class_name Card
extends Control


#region Signals
signal card_played(which_card)
signal card_discarded(which_card)
signal card_flipped(which_card)
#endregion


#region Properties
@export var cost: Dictionary[ValueManager.CreatureValue, int] = {}
@export var description: String = "Placeholder Description"
@export var deck: Deck = null
var is_faceup: bool = true

@onready var _backside: Node = $Back
@onready var _frontside: Node = $Front
@onready var _description_label: Label = $Front/MarginContainer/VBoxContainer/Description
@onready var _costs_hbox: HBoxContainer = $Front/MarginContainer/VBoxContainer/Costs
#endregion


#region Godot Built-in Methods
func _ready() -> void:
	_description_label.text = description
	if is_faceup:
		_frontside.show()
		_backside.hide()
	else:
		_frontside.hide()
		_backside.show()
		
	for cv in cost.keys():
		var letter = ValueManager.value_names[cv][0]
		var label: Label = Label.new()
		label.text = "{0}{1}".format([cost[cv], letter])
		label.add_theme_color_override("font_color", Color.BLACK)
		_costs_hbox.add_child(label)
#endregion


#region Public Methods
func flip() -> void:
	if is_faceup:
		_frontside.hide()
		_backside.show()
	else:
		_frontside.show()
		_backside.hide()
	is_faceup = !is_faceup


func play() -> void:
	_trigger_play_ability()
	card_played.emit(self)


func discard() -> void:
	_trigger_discard_ability()
	card_discarded.emit(self)
#endregion


#region Private Methods
func _trigger_play_ability() -> void:
	pass
	

func _trigger_discard_ability() -> void:
	pass
#endregion


#region Signal Connections
func _on_button_pressed() -> void:
	flip()
#endregion
