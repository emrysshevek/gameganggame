class_name StartingTile
extends Tile


## spawns corresponding player at start of game. 
## Guarantees a path to the storage cache
## cannot have a hazard or resource card at start of round

var player_id: int


func _ready() -> void:
	super._ready()
	Events.game_started.connect(_on_game_started)


func spawn_character() -> void:
	var grid_man := Utils.try_get_grid_man()
	var game_scene := Utils.try_get_game_scene()
	
	var character := game_scene.characters[player_id]
	character.grid_coordinates = grid_coordinates

	#revealing tiles around start tile after player is spawned
	for each_tile in grid_man.get_reachable_tiles(0, grid_coordinates, 1):
		if not each_tile.is_tile_explored:
			each_tile.explore(character)
		#if each_tile.grid_coordinates == grid_coordinates:
			#each_tile.call_deferred("enter", new_character)
		
	#setting up the character sprites visual position and minimap sprite
	character.character_sprite.set_visual_position(Vector2(grid_coordinates.x * grid_man.tile_size.x, grid_coordinates.y * grid_man.tile_size.y))
	character.character_sprite.set_minimap_sprite(load("res://art/character_minimap_icon.png"), Color("#f3e100"))
	character.character_sprite.set_type(Model.ObjectTypes.CHARACTER)
	
	enter(character)


func _on_game_started() -> void:
	spawn_character()
