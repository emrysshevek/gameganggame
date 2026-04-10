class_name Tile extends Node2D

#region signals
signal tile_revealed(which_tile, which_player)
signal tile_explored(which_tile, which_player)
signal tile_entered(which_tile, which_player)
signal tile_exited(which_tile, which_player)
#endregion

#region properties
@export var types: Array[Model.ObjectTypes] = [Model.ObjectTypes.ENTITY, Model.ObjectTypes.TILE, Model.ObjectTypes.HIDDEN_TILE]

#explore means a character has entered the tile and the 'explore value' has been used up
#revealed just means the tile is fully visible to the players, but hasn't been entered
var is_tile_explored:bool = false
var is_tile_revealed:bool = false
var explore_value:Model.CreatureValue

#paths are visually represented by line2Ds, and use the custom Path object
var paths:Dictionary[GridManager.directions, Path]
var _path_lines:Dictionary
#there are separate line2Ds for the paths on the regular map and on the minimap so they can
#be different sizes and colors
var _path_lines_minimap:Dictionary
var a_star_id:int #used by A* for identifying tile

var tile_size:Vector2
var characters: Array[Character] = []

var grid_coordinates:Vector2
var _revealed_texture:Resource

#face down or face up cards on a tile are represented by a GridCards object that contains the cards
#until they are picked up. They are differentiated so eventually face up cards can be identified
#without needing to be on that tile
var grid_cards_face_down:GridCards
var grid_cards_face_up:GridCards

#tiles are set up to only be able to have one hazard for now
var hazard:Hazard = null

@onready var _tile_bkd:Sprite2D = $Tile_Bkgd
@onready var _highlight:Polygon2D = $Tile_Bkgd/SelectionHighlight
@onready var _shading_overlay:Polygon2D = $Front/Overlay
#endregion

#region methods
func _ready() -> void:
		#filling out the path lines dictionaries with the line2D children
		_path_lines[GridManager.directions.north] = $Front/North_Path
		_path_lines[GridManager.directions.east] = $Front/East_Path
		_path_lines[GridManager.directions.south] = $Front/South_Path
		_path_lines[GridManager.directions.west] = $Front/West_Path
		_path_lines_minimap[GridManager.directions.north] = $Front/North_Path_minimap
		_path_lines_minimap[GridManager.directions.east] = $Front/East_Path_minimap
		_path_lines_minimap[GridManager.directions.south] = $Front/South_Path_minimap
		_path_lines_minimap[GridManager.directions.west] = $Front/West_Path_minimap
		_set_random_explore_value()
		#setting default texture for testing
		set_revealed_texture(load("res://art/revealed_test_tile.png"))

func set_coordinates(coords:Vector2):
	#tells the tile where grid_man understands it to be placed on the grid
	#also sets the tile name as its grid coordinates so its easier to find in the viewer
	grid_coordinates = coords
	name = "Tile" + str(grid_coordinates)
	
func reset_to_hidden():
	#used at the end of map generation to set each tile to hidden
	is_tile_explored = false
	is_tile_revealed = false
	types.erase(Model.ObjectTypes.REVEALED_TILE)
	if Model.ObjectTypes.HIDDEN_TILE not in types:
		types.append(Model.ObjectTypes.HIDDEN_TILE)
	_tile_bkd.texture = load("res://art/unrevealed_tile.png")
	
func explore(entering_character:Character):
	#occurs when a character enters the tile, changing the tiles color and generating values
	if is_tile_revealed == false:
		reveal(entering_character)
	is_tile_explored = true
	_shading_overlay.visible = false
	Utils.try_get_value_manager().gain_value(explore_value, 1)
	tile_explored.emit(self, entering_character.character_id)
	
func reveal(entering_character:Character):
	#to be used when a tile is made visible by some card effect but the tile hasn't been explored yet
	is_tile_revealed = true
	types.erase(Model.ObjectTypes.HIDDEN_TILE)
	if Model.ObjectTypes.HIDDEN_TILE not in types:
		types.append(Model.ObjectTypes.REVEALED_TILE)
	tile_revealed.emit(self, entering_character)
	_tile_bkd.texture = _revealed_texture
	$Front.show()

	_shading_overlay.visible = true
	for each_direction in [GridManager.directions.north, GridManager.directions.east, GridManager.directions.south, GridManager.directions.west]:
		if paths.keys().has(each_direction):
			_path_lines[each_direction].visible = true
			_path_lines_minimap[each_direction].visible = true
	

func enter(entering_character:Character):
	#called by grid man when moving a character into a tile
	if is_tile_explored == false:
		explore(entering_character)
	tile_entered.emit(self, entering_character.character_id)
	if hazard != null:
		hazard.trigger_enter_ability(entering_character)
	#if any cards are on the tile in either grid pile they are currently all picked up and added
	#to the characters hand
	pickup_cards(entering_character)
	characters.append(entering_character)


func exit(exiting_character:Character):
	#called by grid man when moving a character out of a tile
	if exiting_character.queued_drop_cards.is_empty() == false:
		#if character discarded any loot cards they are dropped in the tile they are exiting upon exit
		exiting_character.drop_queued_loot_cards()
	tile_exited.emit(self, exiting_character.character_id)
	if hazard != null:
		hazard.trigger_exit_ability(exiting_character)
	characters.erase(exiting_character)


func pickup_cards(character:Character):
	#used when character enters a tile to have them grab all cards in the tile
	#eventually we will want to mechanically differentiate face up/down cards more, but for now theyre the same
	if grid_cards_face_up != null:
		var face_up_pile_count = grid_cards_face_up.pile.count
		for i in face_up_pile_count:
			var top_card = grid_cards_face_up.take_top_card()
			top_card.owning_character = character
			character.my_screen.card_manager.hand_pile.add_card(top_card)
	if grid_cards_face_down != null:
		var face_down_pile_count = grid_cards_face_down.pile.count
		for i in face_down_pile_count:
			var top_card = grid_cards_face_down.take_top_card()
			top_card.owning_character = character
			character.my_screen.card_manager.hand_pile.add_card(top_card)
	if grid_cards_face_up != null || grid_cards_face_down != null:
		Events.looted_cards.emit(character)

func add_hazard(new_hazard:Hazard) -> bool:
	#used by grid man when adding a hazard to a tile during map generation
	if hazard == null:
		hazard = new_hazard
		new_hazard.grid_coordinates = grid_coordinates
		$Front.add_child(new_hazard)
		return true
	else:
		#if for some reason you tried to add a hazard to a tile with a hazard on it, it wouldn't work
		return false
	
func add_grid_card(new_card:Card) -> void:
	#when players drop cards or when cards are added during map generation this function
	#adds the cards to an existing gridcard entity if one exists of the right type (face up/down)
	#or creates a new gridcard entity if an appropriate one doesn't exist yet
	if new_card.is_faceup == true:
		if grid_cards_face_up == null:
			var new_grid_card_pile = GridCards.new()
			new_grid_card_pile.set_facing(true)
			grid_cards_face_up = new_grid_card_pile
			$Front.add_child(new_grid_card_pile)
			grid_cards_face_up.add_card(new_card)
		else:
			grid_cards_face_up.add_card(new_card)
	else:
		if grid_cards_face_down == null:
			var new_grid_card_pile = GridCards.new()
			new_grid_card_pile.set_facing(false)
			grid_cards_face_down = new_grid_card_pile
			$Front.add_child(new_grid_card_pile)
			grid_cards_face_down.add_card(new_card)
		else:
			grid_cards_face_down.add_card(new_card)


func get_contents(types:Array[Model.ObjectTypes]=[]) -> Array[Node]:
	var contents: Array[Node] = [self]
	contents.append_array(characters)
	if hazard != null:
		contents.append(hazard)
	if grid_cards_face_down != null:
		contents.append(grid_cards_face_down)
	if grid_cards_face_up != null:
		contents.append(grid_cards_face_up)
	
	if len(types) == 0:
		return contents
	
	var result: Array[Node] = []
	for item in contents:
		var item_types: Array[Model.ObjectTypes] = item.types
		if item_types.any(func(x): return x in types):
			result.append(item)
	return result


func _set_random_explore_value():
	explore_value = Model.CreatureValue.values().pick_random() #default quantity of 1 always for now
	
func add_path(direction:int, path_obj:Path):
	#used during map creation or when making a new path with a card
	#this sets up the path object relationship on this cards side, but the other side of the path
	#still needs to be set. This should be called from grid man typically
	paths[direction] = path_obj
	_path_lines[direction].show()
	_path_lines_minimap[direction].show()

	
func remove_path(direction:int):
	#removes this tiles path in the specified direction. Tile on the other side will still need 
	#its path removed as well. Should call from grid man to achieve this
	paths[direction] = null
	
func set_highlight(for_character_id:int, highlight_on:bool):
	#used when targetting for a card, highlight is set per player to avoid confusion using masking/culling
	#on the viewports
	if highlight_on == true:
		_highlight.set_visibility_layer_bit(for_character_id + 2, true)
	else:
		_highlight.set_visibility_layer_bit(for_character_id + 2, false)
		
func set_revealed_texture(texture_resource:Resource):
	_revealed_texture = texture_resource
#endregion
