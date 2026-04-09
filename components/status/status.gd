class_name Status

var entity: Entity
var icon: ImageTexture
var status_name: String

@export var _value: float
var value: int:
	get:
		return floori(_value)
	set(val):
		_value = float(val)
		
		
func _init(val: int) -> void:
	value = val


func apply(target: Node) -> bool:
	return true
	
	
func remove() -> bool:
	return true


func update(status: Status) -> void:
	value += status.value


func trigger_effect() -> void:
	pass
