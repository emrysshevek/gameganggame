class_name ValueItem
extends VBoxContainer


@export
var target_value: Model.CreatureValue

var _value_name_label: Label
var _value_quantity_label: Label

var _value_manager: ValueManager


func _ready() -> void:
	_value_name_label = $ValueNameLabel
	_value_quantity_label = $ValueQuantityLabel
	_value_manager = Utils.try_get_value_manager()

	_value_name_label.text = Utils.value_to_string(target_value)[0]
	_value_quantity_label.text = str(_value_manager.get_value(target_value))

	Events.value_changed.connect(_on_value_changed)


func _on_value_changed(value: Model.CreatureValue):
	if value == target_value:
		_value_quantity_label.text = str(_value_manager.get_value(target_value))
