class_name grid_manager extends Node2D

#region signals
signal map_generated()
#endregion

enum directions{north, east, south, west}

#region properties
var _tile_scene = preload("res://scenes/tile.tscn")
var _path_number_odds = [75,75,60,40]
var _direction_opposites:Dictionary
var _a_star_floor_map = {}
var floor_maps = {} #dictionary of arrays of tiles, to allow multiple floors 
var level:int = 0 #dummy
var map_width:int = 20
var map_height:int = 20
#endregion

#region methods
func _ready() -> void:
	_direction_opposites[directions.north] = directions.south
	_direction_opposites[directions.east] = directions.west
	_direction_opposites[directions.south] = directions.north
	_direction_opposites[directions.west] = directions.east
	#initializing A* for map
	_a_star_floor_map[level] = AStar2D.new()
	#
	#initialize blank map grid
	var new_map_grid = []
	for x in range(map_width):
		new_map_grid.append([])
		new_map_grid[x] = []
		for y in range(map_height):
			var new_tile = _tile_scene.instantiate()
			self.add_child(new_tile)
			new_map_grid[x].append([])
			new_map_grid[x][y]=new_tile
			#setup tile for A*. need to modiy this for multi-floors later, as it requires the level to be entered currently
			var a_star_point_id = _a_star_floor_map[0].get_available_point_id()
			_a_star_floor_map[0].add_point(a_star_point_id, Vector2(new_tile.grid_coordinates.x, new_tile.grid_coordinates.y), 0)
			new_tile.a_star_id = a_star_point_id
			#
			#testing visibility
			new_tile.set_coordinates(Vector2(x,y))
			new_tile.global_position = Vector2(x * 120, y * 120)
			#
	floor_maps[level] = new_map_grid
	generate_map(0)
	#reveal_full_map()
	#testing_map_distance_algorithm(Vector2(3,3), 3, 0)
	
func add_path(tile1:tile, connection_direction_from_tile1:directions, tile2:tile):
	var new_path = path.new()
	new_path.set_connections(tile1, tile2)
	tile1.set_path(connection_direction_from_tile1, new_path)
	tile2.set_path(_direction_opposites[connection_direction_from_tile1], new_path)
	if new_path.blocked == false: #blocked paths will not be connected by A* to ensure they aren't considered for pathing
		_a_star_floor_map[level].connect_points(tile1.a_star_id, tile2.a_star_id,true)
	
func _get_all_tiles(level:int):
	var all_tiles:Array[tile]
	for each_y in map_height:
		for each_x in map_width:
			all_tiles.append(floor_maps[level][each_x][each_y])
	return all_tiles
	
func generate_map(level:int):
	for each_tile in _get_all_tiles(0):
		var possible_tile_connections_by_path:Dictionary
		#check which directions could have new paths added to them
		if each_tile.grid_coordinates.x != 0 && each_tile.paths.keys().has(directions.west) == false:
			possible_tile_connections_by_path[directions.west] = floor_maps[level][each_tile.grid_coordinates.x - 1][each_tile.grid_coordinates.y]
		if each_tile.grid_coordinates.y != 0 && each_tile.paths.keys().has(directions.north) == false:
			possible_tile_connections_by_path[directions.north] = floor_maps[level][each_tile.grid_coordinates.x][each_tile.grid_coordinates.y - 1]
		if each_tile.grid_coordinates.x != map_width - 1 && each_tile.paths.keys().has(directions.east) == false:
			possible_tile_connections_by_path[directions.east] = floor_maps[level][each_tile.grid_coordinates.x + 1][each_tile.grid_coordinates.y]
		if each_tile.grid_coordinates.y != map_height - 1 && each_tile.paths.keys().has(directions.south) == false:
			possible_tile_connections_by_path[directions.south] = floor_maps[level][each_tile.grid_coordinates.x][each_tile.grid_coordinates.y + 1]
		var possible_new_path_num = possible_tile_connections_by_path.size()
		for each_num in possible_new_path_num:
			if possible_new_path_num > 0:
				#new paths are added if a random 'roll' is within a set range
				var roll_for_new_path = randi_range(1,100)
				if roll_for_new_path <= _path_number_odds[4 - possible_new_path_num]:
					var connecting_tile_direction_from_origin_tile = possible_tile_connections_by_path.keys().pick_random()
					add_path(each_tile, connecting_tile_direction_from_origin_tile, possible_tile_connections_by_path[connecting_tile_direction_from_origin_tile])
				else:
					possible_new_path_num = 0
					#roll for new path failed, so process to check for creating new paths for current tile ends here
		each_tile.reset_to_hidden()
	map_generated.emit()

func is_reachable(floor:int, from_tile:tile, to_tile:tile): ##dummy
	var path_between_points:Array = _a_star_floor_map[floor].get_id_path(from_tile, to_tile, false)
	if path_between_points.is_empty() == true:
		return false
	else:
		return true
	
func get_reachable_tiles(level:int, starting_tile:tile, range:int): #dummy
	#get all tiles within range 1 of starting tile, add them to checking_tiles
	if range <= 0 || range >= map_width || range >= map_height:
		#eventually change this to just filter the input to a valid max or min value
		print("can't get reachable tiles for range: " + str(range))
		assert(false)
	var return_array:Array[tile]
	var reachable_tile_ids:Array[int]
	#get the 4 or less tile ids surrounding the starting tile and the reachable tiles
	var starting_tile_ids:Array[int]
	starting_tile_ids.append(starting_tile.a_star_id)
	reachable_tile_ids.append_array(_a_star_floor_map[level].get_point_connections(starting_tile.a_star_id))
	for i in range:
		var new_reachable_tile_ids:Array[int]
		#for each of the 4 or less tiles around the starting tile get all of their tile connections
		for each_point_id in starting_tile_ids:
			new_reachable_tile_ids.append_array(_a_star_floor_map[level].get_point_connections(each_point_id))
		#save the newly reached tiles to the array that will be converted to tiles then returned by the function
		for each_new_reachable_tile_id in new_reachable_tile_ids:
			#if the found tile is already in the return array don't search its neighbors again, as they'll already be searched
			if reachable_tile_ids.has(each_new_reachable_tile_id) == false:
				reachable_tile_ids.append(each_new_reachable_tile_id)
		#clear the list of tiles to be checked over in the next round
		starting_tile_ids.clear()
		#add the just-found tiles to be checked for adjacents in the next step
		starting_tile_ids.append_array(new_reachable_tile_ids)
		#clear the tiles for the next round
		new_reachable_tile_ids.clear()
	for each_tile in _get_all_tiles(level):
		if reachable_tile_ids.has(each_tile.a_star_id):
			return_array.append(each_tile)
	#appending the starting tile to the return array so that it is detected as reachable by itself
	return_array.append(starting_tile)
	return return_array

func get_distance(floor:int, from_tile:tile, to_tile:tile):
	var path_between_points:Array = _a_star_floor_map[floor].get_id_path(from_tile, to_tile, false)
	return path_between_points.size()
		
#region testing functions
func reveal_full_map():
	for each_tile in _get_all_tiles(0):
		each_tile.reveal()
		
func testing_map_distance_algorithm(starting_tile_coords:Vector2, range:int, level:int):
	var reached_tiles = get_reachable_tiles(level, floor_maps[level][starting_tile_coords.x][starting_tile_coords.y], range)
	for each_tile in reached_tiles:
		each_tile.reveal()
#endregion
		
func _import_pre_baked_map_section():
	pass
#endregion
