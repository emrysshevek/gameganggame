class_name path extends Node2D

#region properties
var blocked:bool = false #determines if A* will see this as a valid path
var connections:Array[tile]
#endregion

#region methods
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_connections(tile0:tile, tile1:tile):
	connections.clear()
	connections.append(tile0)
	connections.append(tile1)
#endregion
