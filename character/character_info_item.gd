class_name CharacterInfoItem
extends VBoxContainer


@export
var item_name: String

var _item_name_label: Label

var _item_value_label: Label


func _ready() -> void:
	_item_name_label = $ItemNameLabel
	_item_value_label = $ItemValueLabel
	set_item_name(item_name)


func set_item_name(new_name: String) -> void:
	_item_name_label.text = new_name


func set_item_value(new_value: String) -> void:
	_item_value_label.text = new_value
