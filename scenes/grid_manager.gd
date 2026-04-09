class_name GridManager extends Node2D

#region signals
signal map_generated()
#endregion

enum directions{north, east, south, west}

#region properties
var _tile_scene = preload("res://scenes/Tile.tscn")
var _path_number_odds = [75,75,60,40]
var _direction_opposites:Dictionary
var _a_star_floor_map = {}
var floor_maps = {} #dictionary of arrays of tiles, to allow multiple floors 
var level:int = 0 #dummy
var map_width:int = 20
var map_height:int = 20
@onready var tile_size:Vector2 = Vector2(64,64)

#Testing
var _loot_card_scene = preload("res://cards/cards/loot_card/loot_card.tscn")
var test_map_on:bool = true
#endregion

#region methods
func _ready() -> void:
	add_to_group(Config.GRID_MANAGER_GROUP)
	_direction_opposites[directions.north] = directions.south
	_direction_opposites[directions.east] = directions.west
	_direction_opposites[directions.south] = directions.north
	_direction_opposites[directions.west] = directions.east
	#initializing A* for map
	_a_star_floor_map[level] = AStar2D.new()
	#
	floor_maps[level] = setup_map_grid(map_width, map_height)
	if test_map_on == false:
		generate_map(0)
		generate_hazards(0, 10)
		generate_loot_piles(0, 2)
	else:
		setup_test_map(0)
	#reveal_full_map()
	#testing_map_distance_algorithm(Vector2(3,3), 3, 0)
	
func setup_map_grid(width:int, height:int) -> Array:
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
			#setup Tile for A*. need to modiy this for multi-floors later, as it requires the level to be entered currently
			var a_star_point_id = _a_star_floor_map[0].get_available_point_id()
			_a_star_floor_map[0].add_point(a_star_point_id, Vector2(new_tile.grid_coordinates.x, new_tile.grid_coordinates.y), 0)
			new_tile.a_star_id = a_star_point_id
			#
			#testing visibility
			new_tile.set_coordinates(Vector2(x,y))
			new_tile.position = Vector2(x * 64, y * 64)
			#
	return new_map_grid
	
func setup_test_map(level:int):
	var current_floor_tiles = floor_maps[level]
	var tiles:Array[Tile] = _get_all_tiles(level)
	##setting up blank, fully connected outer tiles
	for each_tile in tiles:
		if each_tile.grid_coordinates.x < 8 or each_tile.grid_coordinates.x > 13 and each_tile.grid_coordinates.y < 8 or each_tile.grid_coordinates.y > 13:
			for connecting_tile in get_tiles_in_crow_flies_range(level, each_tile.grid_coordinates, 1):
				if connecting_tile != each_tile:
					add_path(each_tile, connecting_tile)
		##setting up accessible player spawn rooms
		elif each_tile.grid_coordinates.x == 10 or each_tile.grid_coordinates.x == 11 and each_tile.grid_coordinates.y == 10 or each_tile.grid_coordinates.y == 11:
			for connecting_tile in get_tiles_in_crow_flies_range(level, each_tile.grid_coordinates, 1):
				if connecting_tile != each_tile:
					add_path(each_tile, connecting_tile)
	##setting up inaccessable room at 9,9
	#for each_tile in get_tiles_in_crow_flies_range(level, Vector2i(9,9), 1):
		#remove_path(current_floor_tiles[9][9], each_tile)
	##loot pile rooms at 10,9 + 11,9 + 11,12
	add_loot_pile(current_floor_tiles[10][9])
	add_path(current_floor_tiles[10][9], current_floor_tiles[11][9])
	add_path(current_floor_tiles[10][9], current_floor_tiles[10][10])
	add_loot_pile(current_floor_tiles[11][9])
	add_path(current_floor_tiles[11][9], current_floor_tiles[11][10])
	add_path(current_floor_tiles[11][9], current_floor_tiles[12][9])
	add_loot_pile(current_floor_tiles[11][12])
	add_path(current_floor_tiles[11][12], current_floor_tiles[11][11])
	add_path(current_floor_tiles[11][12], current_floor_tiles[12][12])
	##hazards in rooms 12,9 + 12,10 + 12,12
	add_hazard(current_floor_tiles[12][9])
	add_path(current_floor_tiles[12][9], current_floor_tiles[12][10])
	add_hazard(current_floor_tiles[12][10])
	add_path(current_floor_tiles[12][10], current_floor_tiles[11][10])
	##other testing room connections 9,10 + 9,11 + 9,12 + 10,11 + 10,12
	add_path(current_floor_tiles[9][10], current_floor_tiles[10][10])
	add_path(current_floor_tiles[9][10], current_floor_tiles[8][10])
	add_path(current_floor_tiles[9][10], current_floor_tiles[10][10])
	add_path(current_floor_tiles[9][11], current_floor_tiles[10][11])
	add_path(current_floor_tiles[9][12], current_floor_tiles[10][12])
	add_path(current_floor_tiles[10][11], current_floor_tiles[10][12])
	for each_tile in tiles:
		each_tile.reset_to_hidden()
	map_generated.emit()
	
func add_path(tile1:Tile, tile2:Tile):
	var connection_direction = get_path_direction(tile1, tile2)
	var new_path = path.new()
	new_path.set_connections(tile1, tile2)
	tile1.add_path(connection_direction, new_path)
	tile2.add_path(_direction_opposites[connection_direction], new_path)
	if new_path.blocked == false: #blocked paths will not be connected by A* to ensure they aren't considered for pathing
		_a_star_floor_map[level].connect_points(tile1.a_star_id, tile2.a_star_id,true)
	
func remove_path(tile1:Tile, tile2:Tile):
	pass
	
func get_path_direction(tile1:Tile, tile2:Tile) -> directions:
	var connection_direction:directions
	if tile1.grid_coordinates.x < tile2.grid_coordinates.x:
		connection_direction = directions.east
	elif tile1.grid_coordinates.x > tile2.grid_coordinates.x:
		connection_direction = directions.west
	elif tile1.grid_coordinates.y < tile2.grid_coordinates.y:
		connection_direction = directions.south
	else:
		connection_direction = directions.north
	return connection_direction
	
func _get_all_tiles(level:int):
	var all_tiles:Array[Tile]
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
					add_path(each_tile, possible_tile_connections_by_path[connecting_tile_direction_from_origin_tile])
				else:
					possible_new_path_num = 0
					#roll for new path failed, so process to check for creating new paths for current Tile ends here
		each_tile.reset_to_hidden()
	map_generated.emit()

func generate_hazards(level:int, frequency:int):
	for each_tile in _get_all_tiles(level):
		if randi_range(1,frequency) == frequency:
			add_hazard(each_tile)

func add_hazard(tile:Tile) -> void:
	var new_hazard = Hazard.new()
	tile.add_hazard(new_hazard)

func generate_loot_piles(level:int, frequency:int):
	for each_tile in _get_all_tiles(level):
		if randi_range(1,frequency) == frequency:
			add_loot_pile(each_tile)

func add_loot_pile(tile:Tile) -> void:
	for i in randi_range(1,3):
		var new_card:LootCard = _loot_card_scene.instantiate()
		new_card.is_faceup = false
		tile.add_grid_card(new_card)	

func is_reachable(floor:int, from_tile_coords:Vector2, to_tile_coords:Vector2):
	var from_tile = floor_maps[level][from_tile_coords.x][from_tile_coords.y]
	var to_tile = floor_maps[level][to_tile_coords.x][to_tile_coords.y]
	var path_between_points:Array = _a_star_floor_map[floor].get_id_path(from_tile.a_star_id, to_tile.a_star_id, false)
	if path_between_points.is_empty() == true:
		return false
	else:
		return true
	
func get_reachable_tiles(level:int, starting_tile_coords:Vector2, range:int):
	var starting_tile = floor_maps[level][starting_tile_coords.x][starting_tile_coords.y]
	#get all tiles within range 1 of starting Tile, add them to checking_tiles
	if range <= 0 || range >= map_width || range >= map_height:
		#eventually change this to just filter the input to a valid max or min value
		print("can't get reachable tiles for range: " + str(range))
		assert(false)
	var return_array:Array[Tile]
	var reachable_tile_ids:Array[int]
	#get the 4 or less Tile ids surrounding the starting Tile and the reachable tiles
	var starting_tile_ids:Array[int]
	starting_tile_ids.append(starting_tile.a_star_id)
	reachable_tile_ids.append_array(_a_star_floor_map[level].get_point_connections(starting_tile.a_star_id))
	for i in range:
		var new_reachable_tile_ids:Array[int]
		#for each of the 4 or less tiles around the starting Tile get all of their Tile connections
		for each_point_id in starting_tile_ids:
			new_reachable_tile_ids.append_array(_a_star_floor_map[level].get_point_connections(each_point_id))
		#save the newly reached tiles to the array that will be converted to tiles then returned by the function
		for each_new_reachable_tile_id in new_reachable_tile_ids:
			#if the found Tile is already in the return array don't search its neighbors again, as they'll already be searched
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
	#appending the starting Tile to the return array so that it is detected as reachable by itself
	return_array.append(starting_tile)
	return return_array

func get_tiles_in_crow_flies_range(floor:int, from_tile_coords:Vector2, distance:int) -> Array[Tile]:
	var returning_tiles:Array[Tile]
	for each_tile in _get_all_tiles(floor):
		var tile_distance_from_target = abs(each_tile.grid_coordinates.x - from_tile_coords.x) + abs(each_tile.grid_coordinates.y - from_tile_coords.y)
		if tile_distance_from_target <= distance:
			returning_tiles.append(each_tile)
	return returning_tiles

func get_crow_flies_distance(tile1_coords:Vector2, tile2_coords:Vector2):
	return abs(tile1_coords.x - tile2_coords.x) + abs(tile1_coords.y - tile2_coords.y)

func get_distance(floor:int, from_tile_coords:Vector2, to_tile_coords:Vector2):
	var from_tile = floor_maps[level][from_tile_coords.x][from_tile_coords.y]
	var to_tile = floor_maps[level][to_tile_coords.x][to_tile_coords.y]
	#returns distance required to move between the tiles, not as the crow flies
	var path_between_points:Array = _a_star_floor_map[floor].get_id_path(from_tile.a_star_id, to_tile.a_star_id, false)
	return path_between_points.size()
		
func is_directly_connected(floor:int, from_tile_coords:Vector2, to_tile_coords:Vector2):
	var from_tile = floor_maps[level][from_tile_coords.x][from_tile_coords.y]
	var to_tile = floor_maps[level][to_tile_coords.x][to_tile_coords.y]
	var point_connections = _a_star_floor_map[floor].get_point_connections(from_tile.a_star_id)
	#print(str(point_connections))
	if point_connections.has(to_tile.a_star_id):
		return true
	else:
		return false

func is_in_bounds(position_to_check:Vector2):
	#checks if position is in bounds for the grid
	if position_to_check.x < 0:
		return false
	if position_to_check.x > (map_width - 1):
		return false
	if position_to_check.y < 0:
		return false
	if position_to_check.y > (map_height - 1):
		return false
	return true
		
func highlight_targettable_tiles(evaluating_card:Card, origin_point:Vector2, floor:int):
	for tile in _get_all_tiles(floor):
		var contents = tile.get_contents([evaluating_card.targets_required.type])
		if contents.size() > 0:
			for item in contents:
				if evaluating_card.validate_target(item):
					tile.set_highlight(evaluating_card.owning_character.character_id, true)
					break
					
					
func clear_highlights(for_character_id:int, floor:int):
	for each_tile in _get_all_tiles(floor):
		each_tile.set_highlight(for_character_id, false)

func move_object(object, tile_coord:Vector2, floor:int):
	if Model.ObjectTypes.PLAYER_CHARACTER in object.types:
		if is_directly_connected(floor, object.grid_coordinates, tile_coord) == false:
			return false
		else:
			#clearing out movement after entering an unexplored tile
			if floor_maps[floor][tile_coord.x][tile_coord.y].is_tile_explored == false:
				object.movement = 1
			floor_maps[floor][object.grid_coordinates.x][object.grid_coordinates.y].exit(object)
			floor_maps[floor][tile_coord.x][tile_coord.y].enter(object)
			var new_sprite_tile_position:Vector2 = tile_coord
			var new_sprite_screen_position:Vector2 = tile_coord * tile_size
			object.move(new_sprite_tile_position, new_sprite_screen_position)
			#return [new_sprite_tile_position, new_sprite_screen_position]
			
			return true
	else: #should be for ui elements, like the cursor
		if is_in_bounds(tile_coord) == false:
			return false
		else:
			var new_sprite_tile_position:Vector2 = tile_coord
			var new_sprite_screen_position:Vector2 = tile_coord * tile_size
			object.move(new_sprite_tile_position, new_sprite_screen_position)
			#return [new_sprite_tile_position, new_sprite_screen_position]
			return true

func get_tile(grid_coordinates:Vector2) -> Tile:
	#for each object on type_list (we'll have to make these lists) check grid coordinates
	#return array of all objects + the tile itself that match these grid coordinates and type
	#just returning the selected tile for now
	return floor_maps[0][grid_coordinates.x][grid_coordinates.y]
	
func _on_get_tile_request(type, grid_coordinates:Vector2):
	get_tile(grid_coordinates)	
		
func _on_object_move_request(object, new_tile_position:Vector2):
	move_object(object, new_tile_position, 0)
		
#region testing functions
#func reveal_full_map():
	#for each_tile in _get_all_tiles(0):
		#each_tile.explore(0)
		
#func testing_map_distance_algorithm(starting_tile_coords:Vector2, range:int, level:int):
	#var reached_tiles = get_reachable_tiles(level, Vector2(starting_tile_coords.x,starting_tile_coords.y), range)
	#for each_tile in reached_tiles:
		#each_tile.explore(0)
#endregion
		
func _import_pre_baked_map_section():
	pass
#endregion
