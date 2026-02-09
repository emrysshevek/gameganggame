class_name tile extends Node2D

#region signals
signal tile_revealed(which_tile)
signal tile_explored(which_tile)
signal tile_entered(which_tile)
signal tile_exited(which_tile)
#endregion

#region properties
var grid_coordinates:Vector2
var explore_value:int
var is_tile_explored:bool = false
var is_tile_revealed:bool = false
var paths:Dictionary
var path_lines:Dictionary
var a_star_id:int #used by A* for identifying tile
#endregion

#region methods
func _ready() -> void:
		#paths[grid_manager.directions.north] = null
		#paths[grid_manager.directions.east] = null
		#paths[grid_manager.directions.south] = null
		#paths[grid_manager.directions.west] = null
		path_lines[grid_manager.directions.north] = $Tile_Bkgd/North_Path
		path_lines[grid_manager.directions.east] = $Tile_Bkgd/East_Path
		path_lines[grid_manager.directions.south] = $Tile_Bkgd/South_Path
		path_lines[grid_manager.directions.west] = $Tile_Bkgd/West_Path
		#$Tile_Bkgd.self_modulate = Color("000000c0")
		_set_random_explore_value()

func explore():
	if is_tile_revealed == false:
		reveal()
	is_tile_explored = true
	tile_explored.emit(self)
	
func reveal():
	is_tile_revealed = true
	tile_revealed.emit(self)
	$Tile_Bkgd.self_modulate = Color("ffffff")
	for each_direction in [grid_manager.directions.north, grid_manager.directions.east, grid_manager.directions.south, grid_manager.directions.west]:
		if paths.keys().has(each_direction):
			path_lines[each_direction].visible = true
			
func enter(): #dummy
	tile_entered.emit(self)
	pass
	
func exit(): #dummy
	tile_exited.emit(self)
	pass
	
func _set_random_explore_value():
	var values_list = [ValueManager.CreatureValue.ADAPTABILITY, ValueManager.CreatureValue.BRAVERY, ValueManager.CreatureValue.CURIOSITY,ValueManager.CreatureValue.DEPENDABILITY, ValueManager.CreatureValue.EMPATHY]
	explore_value = values_list.pick_random()
	
func set_path(direction:int, path_obj:path):
	paths[direction] = path_obj
#endregion
