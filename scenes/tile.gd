class_name tile extends Node2D

#region signals
signal tile_revealed(which_tile, which_player)
signal tile_explored(which_tile, which_player)
signal tile_entered(which_tile, which_player)
signal tile_exited(which_tile, which_player)
#endregion

#region properties
var grid_coordinates:Vector2
var explore_value:String
var is_tile_explored:bool = false
var is_tile_revealed:bool = false
var paths:Dictionary
var _path_lines:Dictionary
var a_star_id:int #used by A* for identifying tile
#endregion

#region methods
func _ready() -> void:
		_path_lines[grid_manager.directions.north] = $Tile_Bkgd/North_Path
		_path_lines[grid_manager.directions.east] = $Tile_Bkgd/East_Path
		_path_lines[grid_manager.directions.south] = $Tile_Bkgd/South_Path
		_path_lines[grid_manager.directions.west] = $Tile_Bkgd/West_Path
		_set_random_explore_value()

func set_coordinates(coords:Vector2):
	grid_coordinates = coords
	name = "Tile" + str(grid_coordinates)
	
func reset_to_hidden():
	is_tile_explored = false
	is_tile_revealed = false
	$Tile_Bkgd.self_modulate = Color("000000c0")
	
func explore(which_player:player):
	if is_tile_revealed == false:
		reveal(which_player)
	is_tile_explored = true
	tile_explored.emit(self, which_player)
	
func reveal(which_player:player):
	is_tile_revealed = true
	tile_revealed.emit(self, which_player)
	$Tile_Bkgd.self_modulate = Color("fffff0")
	for each_direction in [grid_manager.directions.north, grid_manager.directions.east, grid_manager.directions.south, grid_manager.directions.west]:
		if paths.keys().has(each_direction):
			_path_lines[each_direction].visible = true
			
func enter(which_player:player):
	explore(which_player)
	tile_entered.emit(self, which_player)
	pass
	
func exit(which_player:player):
	tile_exited.emit(self, which_player)
	pass
	
func _set_random_explore_value():
	explore_value = ValueManager.value_names.pick_random()
	
func set_path(direction:int, path_obj:path):
	paths[direction] = path_obj
#endregion
