class_name Card
extends Control


#region Signals
signal clicked()
signal activate_effect(which_card)
#endregion


#region Properties
@export var cost: Dictionary[ValueManager.CreatureValue, int] = {}
@export var description: String = "Placeholder Description"
@export var character_sprite: CharacterSprite
@export var deck: Deck = null
@export var pile: Pile = null
var is_faceup: bool = true

@export var focus: Focusable

@export var _backside: Node
@export var _frontside: Node
@export var _description_label: Label
@export var _costs_hbox: HBoxContainer

var owning_character_id:int #should change this to a reference to the character later
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
	Events.card_played.emit(self)


func discard() -> void:
	_trigger_discard_ability()
	Events.card_discarded.emit(self)
	
func highlight_react() -> void:
	scale = Vector2(1.5, 1.5)
	
func highlight_return():
	scale = Vector2(1,1)
#endregion


#region Private Methods
func _trigger_play_ability() -> void:
	activate_effect.emit(self)
	

func _trigger_discard_ability() -> void:
	pass
#endregion


#region Signal Connections
func _on_button_pressed() -> void:
	play()
	clicked.emit()
	
	
func _on_focus_entered() -> void:
	pass
	
	
func _on_focus_exited() -> void:
	pass
#endregion
