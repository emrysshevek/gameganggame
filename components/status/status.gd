class_name Status

signal remove_status(status: Status)

var entity: Node
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
	entity = target
	return true
	
	
func remove() -> bool:
	return true


func update(status: Status) -> void:
	value += status.value


func trigger_effect() -> void:
	print("Triggering status effect: ", status_name)
