class_name CharacterInfo
extends HBoxContainer


var _character: Character

var _health_info: CharacterInfoItem
var _movement_info: CharacterInfoItem


func _ready() -> void:
	_health_info = $HealthInfo
	_movement_info = $MovementInfo

	if _character:
		_health_info.set_item_value(str(_character.health_current))
		_movement_info.set_item_value(str(_character.movement))

	Events.character_health_changed.connect(_on_health_changed)
	Events.character_movement_value_changed.connect(_on_movement_changed)


func set_character(character: Character) -> void:
	_character = character
	if _health_info:
		_health_info.set_item_value(str(_character.health_current))
	if _movement_info:
		_movement_info.set_item_value(str(_character.movement))


func _on_health_changed(character: Character, new_value: int) -> void:
	if character == _character:
		_health_info.set_item_value(str(new_value))


func _on_movement_changed(character: Character, _old_value: int, new_value: int) -> void:
	if character == _character:
		_movement_info.set_item_value(str(new_value))
