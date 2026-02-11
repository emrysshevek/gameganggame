class_name player_viewport extends Node

func _ready() -> void:
	#$SubViewportContainer.size = DisplayServer.window_get_size()
	#$GridManager.generate_map(0)
	var world:World2D = $HBoxContainer/SubViewportContainer/SubViewport.find_world_2d()
	$HBoxContainer/SubViewportContainer2/SubViewport.world_2d = world
