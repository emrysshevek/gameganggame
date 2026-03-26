class_name Character extends Node2D

#region signals
signal health_changed(which_player, old_value, new_value)
signal move_request(which_sprite, requested_position)
signal moved(which_player, old_coord, new_coord)
signal died(which_player)
signal ended_turn(which_player)
signal started_turn(which_player)
#endregion

#region properties
var input_man:PlayerInputManager
var pis_machine:PlayerInputStateMachine
var my_screen:PlayerScreen
var character_id:int
var health_max:int = 5
var health_current:int
var deck:Deck
var grid_coordinates:Vector2
var current_floor:int
var movement:int = 3
var character_sprite:CharacterSprite
var cursor_sprite:CursorSprite
var character_color:Color
var queued_drop_cards:Array[Card]
@onready var type = Model.ObjectTypes.PLAYER_CHARACTER

@onready var testing_player_colors:Array = [Color("23b9d6"), Color("f164e8"), Color("e0b81e"), Color("8084fd")]
#endregion

#region methods
func setup_new_character(input_character_id:int, input_state_machine:PlayerInputStateMachine) -> Character:
	character_id = input_character_id
	input_man = InputManager.get_player_input_manager(character_id)
	pis_machine = input_state_machine
	return self

func bind_screen(input_screen:PlayerScreen):
	my_screen = input_screen
	
func bind_character_sprite(input_sprite:CharacterSprite):
	character_sprite = input_sprite
	character_sprite.input_man = input_man
	character_sprite.self_modulate = testing_player_colors[character_id]
	character_sprite.type = Model.ObjectTypes.PLAYER_CHARACTER
	add_child(character_sprite)
	
func bind_cursor_sprite(input_sprite:CursorSprite):
	cursor_sprite = input_sprite
	cursor_sprite.input_man = input_man
	cursor_sprite.input_state_machine = pis_machine
	cursor_sprite.self_modulate = testing_player_colors[character_id]
	cursor_sprite.character_ref = self
	add_child(cursor_sprite)

func bind_deck(new_deck:Deck):
	deck = new_deck
	add_child(deck)

func bind_pis_machine(input_pis_machine:PlayerInputStateMachine):
	pis_machine = input_pis_machine
	pis_machine.character = self
	pis_machine.state_switched.connect(_on_state_machine_switched)

func take_damage(amount:int):
	health_current -= amount
	health_changed.emit(self, health_current + amount, health_current)
	if health_current <= 0:
		die()
		
func heal(amount:int):
	health_current += amount
	if health_current > health_max:
		health_current = health_max
	
func die():
	died.emit(self)

func forced_random_discard(number_of_cards:int):
	for i in number_of_cards:
		var random_card = my_screen.card_manager.hand_pile.get_random_card()
		if random_card != null:
			my_screen.card_manager.discard(my_screen.card_manager.hand_pile.get_random_card())

func end_turn():
	ended_turn.emit(self)

func start_turn():
	started_turn.emit(self)
	
func _process(_delta: float) -> void:
	if pis_machine.current_state == Model.InputState.MOVE:
		_handle_input()

func drop_queued_loot_cards():
	if queued_drop_cards.is_empty() == false:
		var drop_tile:Tile = Utils.try_get_grid_man().floor_maps[current_floor][grid_coordinates.x][grid_coordinates.y]
		for each_card in queued_drop_cards:
			my_screen.card_manager.remove_card(each_card)
			each_card.owning_character = null
			drop_tile.add_grid_card(each_card)
	queued_drop_cards.clear()

func move(new_grid_position:Vector2, new_screen_position:Vector2):
	drop_queued_loot_cards()
	var old_grid_position = grid_coordinates
	grid_coordinates = new_grid_position
	movement -= 1
	character_sprite.position = new_screen_position
	moved.emit(self, old_grid_position, new_grid_position)
	
func _handle_input():
	if movement > 0:
		if input_man.is_action_just_released("move_up"):
			move_request.emit(self, Vector2(grid_coordinates.x, grid_coordinates.y - 1))
		elif input_man.is_action_just_released("move_right"):
			move_request.emit(self, Vector2(grid_coordinates.x + 1, grid_coordinates.y))
		elif input_man.is_action_just_released("move_down"):
			move_request.emit(self, Vector2(grid_coordinates.x, grid_coordinates.y + 1))
		elif input_man.is_action_just_released("move_left"):
			move_request.emit(self, Vector2(grid_coordinates.x - 1, grid_coordinates.y))

func get_my_current_playing_card():
	return my_screen.card_manager.card_being_played

#endregion

func _on_state_machine_switched(old_state:String, new_state:String):
	if new_state == Model.InputState.CURSOR or old_state == Model.InputState.CURSOR or new_state == Model.InputState.TARGET || old_state == Model.InputState.TARGET:
		cursor_sprite.move(grid_coordinates, character_sprite.position)
		cursor_sprite.toggle_visibility()
		if cursor_sprite.visible == true:
			cursor_sprite.set_remote_camera_transform(my_screen.player_sub_viewport.camera)
		else:
			character_sprite.set_remote_camera_transform(my_screen.player_sub_viewport.camera)
		if new_state == Model.InputState.TARGET:
			Utils.try_get_grid_man().highlight_targettable_tiles(get_my_current_playing_card(), grid_coordinates, 0)
		if old_state == Model.InputState.TARGET:
			Utils.try_get_grid_man().clear_highlights(character_id, 0)
