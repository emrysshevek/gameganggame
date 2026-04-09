extends Node

@export var entity: Entity
@export var icon: ImageTexture

@export var _value: float
var value: int:
	get:
		return floori(_value)
	set(val):
		_value = float(val)


func trigger_effect() -> void:
	pass
