class_name ValueManager
extends Node


#region Properties
static var _creature_values: Dictionary[Model.CreatureValue, int] = {}
static var _reserved_values: Dictionary[Model.CreatureValue, int] = {}
#endregion


#region Public Methods
func _ready() -> void:
	for i in range(Config.CREATURE_VALUE_COUNT):
		_creature_values[i as Model.CreatureValue] = 0
		_reserved_values[i as Model.CreatureValue] = 0
	add_to_group(Config.VALUE_MANAGER_GROUP)


func get_value(value: Model.CreatureValue) -> int:
	return _creature_values[value]


func gain_value(value: Model.CreatureValue, quantity: int = 1) -> void:
	_increase_value(value, quantity)
	print('added %d %s' % [
		quantity, Utils.value_to_string(value)
	])


func reserve_value(value: Model.CreatureValue, quantity: int = 1) -> bool:
	if _creature_values[value] < quantity:
		return false
	_creature_values[value] -= quantity
	_reserved_values[value] += quantity
	return true


func use_reserved_value(value: Model.CreatureValue, quantity: int = 1) -> bool:
	if _reserved_values[value] < quantity:
		return false
	_reserved_values[value] -= quantity
	_creature_values[value] += quantity
	return use_value(value, quantity)


func release_values() -> void:
	for i in range(len(_reserved_values)):
		var quantity = _reserved_values[i]
		_reserved_values[i] -= quantity
		_creature_values[i] += quantity


func use_value(value: Model.CreatureValue, quantity: int = 1) -> bool:
	if _creature_values[value] < quantity:
		return false
	var next_value = _get_next_value(value)
	_decrease_value(value, quantity)
	_increase_value(next_value, quantity)
	print('transformed %d %s into %d %s' % [
		quantity, Utils.value_to_string(value),
		quantity, Utils.value_to_string(next_value)
	])
	return true
#endregion


#region Private Methods
func _get_next_value(which_value: Model.CreatureValue) -> Model.CreatureValue:
	var next_value = (which_value + 1) % Config.CREATURE_VALUE_COUNT
	return next_value as Model.CreatureValue


func _increase_value(which_value: Model.CreatureValue, amount: int) -> int:
	_creature_values[which_value] += amount
	Events.value_changed.emit(which_value)
	return _creature_values[which_value]


func _decrease_value(which_value: Model.CreatureValue, amount: int) -> int:
	_creature_values[which_value] -= amount
	Events.value_changed.emit(which_value)
	return _creature_values[which_value]


func reduce_values() -> void:
	for i in Config.CREATURE_VALUE_COUNT:
		_creature_values[i] /= 2
		Events.value_changed.emit(i as Model.CreatureValue)


func clear_values() -> void:
	for i in Config.CREATURE_VALUE_COUNT:
		_creature_values[i] = 0
		Events.value_changed.emit(i as Model.CreatureValue)
#endregion
