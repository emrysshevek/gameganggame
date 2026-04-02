class_name Tile extends Node2D

#region signals
signal tile_revealed(which_tile, which_player)
signal tile_explored(which_tile, which_player)
signal tile_entered(which_tile, which_player)
signal tile_exited(which_tile, which_player)
#endregion

#region properties
@export var types: Array[Model.ObjectTypes] = [Model.ObjectTypes.ENTITY, Model.ObjectTypes.TILE, Model.ObjectTypes.HIDDEN_TILE]
var grid_coordinates:Vector2
var explore_value:Model.CreatureValue
var is_tile_explored:bool = false
var is_tile_revealed:bool = false
var paths:Dictionary
var _path_lines:Dictionary
var _path_lines_minimap:Dictionary
var a_star_id:int #used by A* for identifying tile
var tile_size:Vector2
var grid_cards_face_down:GridCards
var grid_cards_face_up:GridCards
@onready var hazard:Hazard = null
@onready var _tile_bkd:Sprite2D = $Tile_Bkgd
@onready var _highlight:Polygon2D = $Tile_Bkgd/SelectionHighlight
var _revealed_texture:Resource
#endregion

#region methods
func _ready() -> void:
		_path_lines[GridManager.directions.north] = $Tile_Bkgd/North_Path
		_path_lines[GridManager.directions.east] = $Tile_Bkgd/East_Path
		_path_lines[GridManager.directions.south] = $Tile_Bkgd/South_Path
		_path_lines[GridManager.directions.west] = $Tile_Bkgd/West_Path
		_path_lines_minimap[GridManager.directions.north] = $Tile_Bkgd/North_Path_minimap
		_path_lines_minimap[GridManager.directions.east] = $Tile_Bkgd/East_Path_minimap
		_path_lines_minimap[GridManager.directions.south] = $Tile_Bkgd/South_Path_minimap
		_path_lines_minimap[GridManager.directions.west] = $Tile_Bkgd/West_Path_minimap
		_set_random_explore_value()
		#setting default texture for testing
		set_revealed_texture(load("res://art/revealed_test_tile.png"))

func set_coordinates(coords:Vector2):
	grid_coordinates = coords
	name = "Tile" + str(grid_coordinates)
	
func reset_to_hidden():
	is_tile_explored = false
	is_tile_revealed = false
	types.erase(Model.ObjectTypes.REVEALED_TILE)
	types.append(Model.ObjectTypes.HIDDEN_TILE)
	_tile_bkd.texture = load("res://art/unrevealed_tile.png")
	#_tile_bkd.self_modulate = Color("000000c0")
	
func explore(entering_character:Character):
	if is_tile_revealed == false:
		reveal(entering_character)
	is_tile_explored = true
	_tile_bkd.self_modulate = Color("ffffff")
	Utils.try_get_value_manager().gain_value(explore_value, 1)
	tile_explored.emit(self, entering_character.character_id)
	
func reveal(entering_character:Character):
	is_tile_revealed = true
	types.erase(Model.ObjectTypes.HIDDEN_TILE)
	types.append(Model.ObjectTypes.REVEALED_TILE)
	tile_revealed.emit(self, entering_character)
	if hazard != null:
		hazard.visible = true
	if grid_cards_face_down != null:
		grid_cards_face_down.visible = true
	if grid_cards_face_up != null:
		grid_cards_face_up.visible = true
	_tile_bkd.texture = _revealed_texture
	_tile_bkd.self_modulate = Color("858585")
	for each_direction in [GridManager.directions.north, GridManager.directions.east, GridManager.directions.south, GridManager.directions.west]:
		if paths.keys().has(each_direction):
			_path_lines[each_direction].visible = true
			_path_lines_minimap[each_direction].visible = true
			
func enter(entering_character:Character):
	if is_tile_explored == false:
		explore(entering_character)
	tile_entered.emit(self, entering_character.character_id)
	if hazard != null:
		hazard.trigger_enter_ability(entering_character)
	pickup_cards(entering_character)
	
func exit(exiting_character:Character):
	if exiting_character.queued_drop_cards.is_empty() == false:
		exiting_character.drop_queued_loot_cards()
	tile_exited.emit(self, exiting_character.character_id)
	if hazard != null:
		hazard.trigger_exit_ability(exiting_character)

func pickup_cards(character:Character):
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

func add_hazard(new_hazard:Hazard) -> bool:
	if hazard == null:
		hazard = new_hazard
		new_hazard.grid_coordinates = grid_coordinates
		add_child(new_hazard)
		return true
	else:
		return false
	
func add_grid_card(new_card:Card) -> void:
	if new_card.is_faceup == true:
		if grid_cards_face_up == null:
			var new_grid_card_pile = GridCards.new()
			new_grid_card_pile.set_facing(true)
			grid_cards_face_up = new_grid_card_pile
			add_child(new_grid_card_pile)
			if is_tile_revealed == true:
				new_grid_card_pile.visible = true
			grid_cards_face_up.add_card(new_card)
		else:
			grid_cards_face_up.add_card(new_card)
	else:
		if grid_cards_face_down == null:
			var new_grid_card_pile = GridCards.new()
			new_grid_card_pile.set_facing(false)
			grid_cards_face_down = new_grid_card_pile
			add_child(new_grid_card_pile)
			if is_tile_revealed == true:
				new_grid_card_pile.visible = true
			grid_cards_face_down.add_card(new_card)
		else:
			grid_cards_face_down.add_card(new_card)
	
func _set_random_explore_value():
	explore_value = Model.CreatureValue.values().pick_random() #default quantity of 1 always for now
	
func set_path(direction:int, path_obj:path):
	paths[direction] = path_obj
	
func set_highlight(for_character_id:int, highlight_on:bool):
	if highlight_on == true:
		_highlight.set_visibility_layer_bit(for_character_id + 2, true)
	else:
		_highlight.set_visibility_layer_bit(for_character_id + 2, false)
		
func set_revealed_texture(texture_resource:Resource):
	_revealed_texture = texture_resource
#endregion
