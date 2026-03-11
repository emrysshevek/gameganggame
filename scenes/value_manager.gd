class_name ValueManager
extends Node

#region Signals
signal creature_value_increased(which_value, amount)
signal creature_value_decreased(which_value, amount)
signal creature_values_reduced()
signal creature_values_cleared()
#endregion


#region Properties
static var _creature_values: Array[Model.CreatureValue] = [0,0,0,0,0]
static var _reserved_values: Array[Model.CreatureValue] = [0,0,0,0,0]
static var _value_names: Array[String] = [
	"adaptability",
	"bravery",
	"curiosity",
	"dependability",
	"empathy",
]
#endregion


#region Public Methods
func _ready() -> void:
	add_to_group(Config.VALUE_MANAGER_GROUP)


func get_value(value: Model.CreatureValue) -> int:
	return _creature_values[value]


func gain_value(value: Model.CreatureValue, quantity: int = 1) -> void:
	_increase_value(value, quantity)


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
	return true
#endregion


#region Private Methods
func _get_next_value(which_value: Model.CreatureValue) -> Model.CreatureValue:
	return (which_value + 1) % len(_creature_values)


func _increase_value(which_value: Model.CreatureValue, amount: int) -> int:
	_creature_values[which_value] += amount
	creature_value_increased.emit(_creature_values[which_value], amount)
	return _creature_values[which_value]


func _decrease_value(which_value: Model.CreatureValue, amount: int) -> int:
	_creature_values[which_value] -= amount
	creature_value_decreased.emit(which_value, amount)
	return _creature_values[which_value]


func reduce_values() -> void:
	for i in len(_creature_values):
		_creature_values[i] /= 2
	creature_values_reduced.emit()


func clear_values() -> void:
	for i in len(_creature_values):
		_creature_values[i] = 0
	creature_values_cleared.emit()
#endregion

#region Testing
func check_values(which_value: CreatureValue, amount: int, source_of_check):
	#if values are available then reserve them, return true, and store the reservation with a ref to the reserving card?
	return true
	#if values are not available:
	#return false
#endregion
