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
			#testing visibility
			new_tile.grid_coordinates = Vector2(x,y)
			new_tile.global_position = Vector2(x * 120, y * 120)
			#
	#initializing A* for map
	_a_star_floor_map[level] = AStar2D.new()
	#
	floor_maps[level] = new_map_grid
	generate_map(0)
	reveal_full_map()
	
func _get_all_tiles(level:int):
	var all_tiles:Array[tile]
	for each_y in map_height:
		for each_x in map_width:
			all_tiles.append(floor_maps[level][each_x][each_y])
	return all_tiles
	
func generate_map(level:int):
	for each_tile in _get_all_tiles(0):
		#setup tile for A*
		var a_star_point_id = _a_star_floor_map[level].get_available_point_id()
		_a_star_floor_map[level].add_point(a_star_point_id, Vector2(each_tile.grid_coordinates.x, each_tile.grid_coordinates.y), 0)
		each_tile.a_star_id = a_star_point_id
		#
		var possible_tile_connections_by_path:Dictionary
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
				var roll_for_new_path = randi_range(1,100)
				if roll_for_new_path <= _path_number_odds[4 - possible_new_path_num]:
					var new_path = path.new()
					var new_path_direction_from_this_tile = possible_tile_connections_by_path.keys().pick_random()
					new_path.set_connections(each_tile, possible_tile_connections_by_path[new_path_direction_from_this_tile])
					each_tile.set_path(new_path_direction_from_this_tile, new_path)
					possible_tile_connections_by_path[new_path_direction_from_this_tile].set_path(_direction_opposites[new_path_direction_from_this_tile], new_path)
					_a_star_floor_map[level].connect_points(each_tile.a_star_id, possible_tile_connections_by_path[new_path_direction_from_this_tile].a_star_id,true)
				else:
					possible_new_path_num = 0
					#roll for new path failed, so process to check for creating new paths ends here
	map_generated.emit()

func is_reachable(from_tile:tile, to_tile:tile): ##dummy
	return false
	
func get_reachable_tiles(from_tile:tile, range:int): #dummy
	#only works for range 0 currently
	var return_array = []
	for each_path in from_tile.paths:
		if each_path != null:
			for each_connection in each_path.connections:
				if each_connection != self: #so that the tile doesn't return itself as reachable over and over
					return_array.append(each_connection)
	return return_array

func get_distance(from_tile:tile, to_tile:tile):
	return 1
		
#region testing functions
func reveal_full_map():
	for each_tile in _get_all_tiles(0):
		each_tile.reveal()
#endregion
		
func _import_pre_baked_map_section():
	pass
#endregion
