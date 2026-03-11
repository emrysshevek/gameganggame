class_name ValueManager
extends Node

#region Signals
signal creature_value_increased(which_value, amount)
signal creature_value_decreased(which_value, amount)
signal creature_values_reduced()
signal creature_values_cleared()
#endregion


#region Properties
static var creature_values: Array[Model.CreatureValue] = [0,0,0,0,0]
static var value_names: Array[String] = [
	"adaptability",
	"bravery",
	"curiosity",
	"dependability",
	"empathy",
]
#endregion


#region Methods
func _ready() -> void:
	add_to_group(Config.VALUE_MANAGER_GROUP)


func get_next_value(which_value: Model.CreatureValue) -> Model.CreatureValue:
	return (which_value + 1) % len(creature_values)


func increase_value(which_value: Model.CreatureValue, amount: int) -> int:
	creature_values[which_value] += amount
	creature_value_increased.emit(creature_values[which_value], amount)
	return creature_values[which_value]


func decrease_value(which_value: Model.CreatureValue, amount: int) -> int:
	creature_values[which_value] += amount
	creature_value_decreased.emit(which_value, amount)
	return creature_values[which_value]


func reduce_values() -> void:
	for i in len(creature_values):
		creature_values[i] /= 2
	creature_values_reduced.emit()


func clear_values() -> void:
	for i in len(creature_values):
		creature_values[i] = 0
	creature_values_cleared.emit()
#endregion
