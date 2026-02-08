class_name ValueManager
extends Node

#region Signals
signal creature_value_increased(which_value)
signal creature_value_decreased(which_value)
signal creature_values_reduced()
signal creature_values_cleared()
#endregion


enum CreatureValue {
	ADAPTABILITY,
	BRAVERY,
	CURIOSITY,
	DEPENDABILITY,
	EMPATHY
}

#region Properties
var creature_values: Array[CreatureValue] = [0,0,0,0,0]
var value_names: Array[String] = [
	"adaptability",
	"bravery",
	"curiosity",
	"dependability",
	"empathy",
]
#endregion


#region Methods
func get_next_value(which_value: CreatureValue) -> CreatureValue:
	return (which_value + 1) % len(creature_values)


func increase_value(which_value: CreatureValue, amount: int) -> int:
	creature_values[which_value] += amount
	return creature_values[which_value]


func decrease_value(which_value, amount) -> int:
	creature_values[which_value] += amount
	return creature_values[which_value]


func reduce_values() -> void:
	for i in len(creature_values):
		creature_values[i] /= 2


func clear_values() -> void:
	for i in len(creature_values):
		creature_values[i] = 0
#endregion
