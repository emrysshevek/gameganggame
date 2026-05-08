class_name CharacterInfoItem
extends VBoxContainer


@export
var item_name: String

@onready
var _item_name_label: Label = $ItemNameLabel

@onready
var _item_value_label: Label = $ItemValueLabel


func _ready() -> void:
	set_item_name(item_name)


func set_item_name(new_name: String) -> void:
	_item_name_label.text = new_name


func set_item_value(new_value: String) -> void:
	_item_value_label.text = new_value
