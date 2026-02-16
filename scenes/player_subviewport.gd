class_name PlayerSubViewport extends SubViewportContainer

#region properties
@onready var subviewport:SubViewport = $PlayerSubViewport
@onready var camera:Camera2D = $PlayerSubViewport/PlayerCamera
#endregion

#region methods
func set_viewport_world(world:World2D):
	subviewport.world_2d = world
	
func set_zoom(zoom_level:Vector2):
	camera.zoom = zoom_level
	
func set_camera_limits(left:int, top:int, right:int, bottom:int):
	camera.limit_left = left
	camera.limit_top = top
	camera.limit_right = right
	camera.limit_bottom = bottom
	
func move_camera(coords:Vector2):
	camera.global_position = coords
	
func set_bounds(bounds:Vector2):
	custom_minimum_size = bounds
	size = bounds
	
func toggle_background():
	$Background.visible = !$Background.visible
	$Background.position = Vector2(-10,-10)
	$Background.custom_minimum_size = custom_minimum_size + Vector2(20,20)
	
func set_fade(percent:float):
	modulate.a = percent
#endregion
