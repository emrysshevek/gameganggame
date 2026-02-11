class_name Card
extends Control


#region Signals
signal request_discard(_card: Card)
#endregion


#region Properties
@export var cost: Dictionary[ValueManager.CreatureValue, int] = {}
@export var description: String = "Placeholder Description"
@export var deck: Deck = null
@export var pile: Pile = null
var is_faceup: bool = true

@export var _backside: Node
@export var _frontside: Node
@export var _description_label: Label
@export var _costs_hbox: HBoxContainer
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
	request_discard.emit()


func discard() -> void:
	_trigger_discard_ability()
	request_discard.emit()
#endregion


#region Private Methods
func _trigger_play_ability() -> void:
	pass
	

func _trigger_discard_ability() -> void:
	pass
#endregion


#region Signal Connections
func _on_button_pressed() -> void:
	request_discard.emit()
#endregion
