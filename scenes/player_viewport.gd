class_name player_viewport extends Node

func _ready() -> void:
	#$SubViewportContainer.size = DisplayServer.window_get_size()
	$HBoxContainer/SubViewportContainer/SubViewport/Camera2D.offset.y = 300
	$HBoxContainer/SubViewportContainer2/SubViewport/Camera2D.offset.y = 300
	var world:World2D = $HBoxContainer/SubViewportContainer/SubViewport.find_world_2d()
	$HBoxContainer/SubViewportContainer2/SubViewport.world_2d = world
	$HBoxContainer/SubViewportContainer/SubViewport/GridManager.generate_map(0)
