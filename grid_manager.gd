class_name grid_manager extends Node2D

signal map_generated()

var floor_maps = {} #dictionary of arrays of tiles, to allow multiple floors 
var floor:int = 0 #dummy
var map_width:int
var map_height:int

func _ready() -> void:
	#initialize blank map grid
	var new_map_grid = []
	for x in range(map_width):
		new_map_grid.append([])
		new_map_grid[x] = []
		for y in range(map_height):
			var new_tile = tile.new()
			new_map_grid[x].append([])
			new_map_grid[x][y]=new_tile
			new_tile.grid_coordinates = Vector2(x,y)
	floor_maps[floor] = new_map_grid
	
func generate_map(floor:int):
	for each_tile in floor_maps[floor]:
		each_tile.get_reachable_tiles(1)
		
func import_pre_baked_map_section():
	pass
