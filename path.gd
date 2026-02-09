class_name path extends Node2D

var blocked:bool = false
var connections:Array 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_connections(tile0:tile, tile1:tile):
	connections[0] = tile0
	connections[1] = tile1
