class_name tile extends Node2D

signal tile_revealed(which_tile)
signal tile_explored(which_tile)
signal tile_entered(which_tile)
signal tile_exited(which_tile)

var grid_coordinates:Vector2
var explore_value:int
var is_tile_explored:bool = false
var is_tile_revealed:bool = false
var paths:Dictionary
var path_lines:Dictionary

func _ready() -> void:
		paths[grid_manager.directions.north] = null
		paths[grid_manager.directions.east] = null
		paths[grid_manager.directions.south] = null
		paths[grid_manager.directions.west] = null
		path_lines[grid_manager.directions.north] = $Tile_Bkgd/North_Path
		path_lines[grid_manager.directions.east] = $Tile_Bkgd/East_Path
		path_lines[grid_manager.directions.south] = $Tile_Bkgd/South_Path
		path_lines[grid_manager.directions.west] = $Tile_Bkgd/West_Path
		$Tile_Bkgd.self_modulate = Color("000000c0")
		_set_random_explore_value()

func is_reachable(): ##dummy
	return false
	
func get_reachable_tiles(range:int): #dummy
	#only works for range 0 currently
	var return_array = []
	for each_tile in paths:
		if each_tile != null:
			return_array.append(each_tile)
	return return_array

func get_distance(): #dummy
	return 1

func explore():
	if is_tile_revealed == false:
		reveal()
	is_tile_explored = true
	tile_explored.emit(self)
	
func reveal():
	is_tile_revealed = true
	tile_revealed.emit(self)
	$Tile_Bkgd.self_modulate = Color("ffffff")
	for each_direction in grid_manager.directions:
		if paths[each_direction] != null:
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
	
func set_path_tile(direction:int, path_leads_to_tile:tile):
	paths[direction] = path_leads_to_tile
