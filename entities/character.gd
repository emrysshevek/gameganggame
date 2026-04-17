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
#setting type of character object
@export var status_manager: StatusManager
@export var types: Array[Model.ObjectTypes] = [
	Model.ObjectTypes.ENTITY, 
	Model.ObjectTypes.CHARACTER, 
	Model.ObjectTypes.PLAYER_CHARACTER
]

#machines and other character child objects
var input_man:PlayerInputManager
var pis_machine:PlayerInputStateMachine
var my_screen:PlayerScreen
var deck:Deck

var character_sprite:CharacterSprite
var cursor_sprite:CursorSprite

@onready var type = Model.ObjectTypes.PLAYER_CHARACTER


#used for identifying character, also eventually for controller mapping i think
var character_id:int

#character basic info
var health_max:int = 5
var health_current:int
var grid_coordinates:Vector2
var current_floor:int
#movement starts at 3 so character can move a big right at the game start, for testing
var movement:int = 3 :
	set(new_val):
		var old_val := movement
		movement = new_val
		Events.character_movement_value_changed.emit(self, old_val, new_val)
		
#colors define color of the sprite and minimap icon
var character_color:Color
var testing_player_colors:Array = [Color("23b9d6"), Color("f164e8"), Color("e0b81e"), Color("8084fd")]

#these are the loot cards the player has discarded that are waiting to drop into the tile they exit when they move
var queued_drop_cards:Array[Card]

#endregion

#region methods
func setup_new_character(input_character_id:int, input_state_machine:PlayerInputStateMachine) -> Character:
	#called by game scene when creating this new character, hooking up its child objects and signals
	character_id = input_character_id
	input_man = InputManager.get_player_input_manager(character_id)
	pis_machine = input_state_machine
	Events.looted_cards.connect(_on_looted_card)
	return self

#region Binding Functions
#these binding functions below are just accepting an object created in game_scene and adding it to the
#appropriate variable on the character

func bind_screen(input_screen:PlayerScreen):
	my_screen = input_screen
	my_screen.card_manager.character = self
	
func bind_character_sprite(input_sprite:CharacterSprite):
	character_sprite = input_sprite
	character_sprite.input_man = input_man
	character_sprite.self_modulate = testing_player_colors[character_id]
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
	deck.character = self
	add_child(deck)

func bind_pis_machine(input_pis_machine:PlayerInputStateMachine):
	pis_machine = input_pis_machine
	pis_machine.character = self
	pis_machine.state_switched.connect(_on_state_machine_switched)
#endregion

func take_damage(amount:int):
	#call this when the player takes damage to adjust their hp and play the 'animation' and popup
	health_current -= amount
	health_changed.emit(self, health_current + amount, health_current)
	character_sprite.damage_animation()
	character_sprite.play_pop_up("-" + str(amount) + "hp", Color("b82d1d"))
	if health_current <= 0:
		die()
		
func heal(amount:int):
	#no pop-up or animation for this yet
	health_current += amount
	if health_current > health_max:
		health_current = health_max
	
func die():
	#don't think we're using this yet
	died.emit(self)

func forced_random_discard(number_of_cards:int):
	#the test hazard is set up to force a player to discard a random card from hand
	#if players hand is empty does nothing
	for i in number_of_cards:
		var random_card = my_screen.card_manager.hand_pile.get_random_card()
		if random_card != null:
			my_screen.card_manager.discard_pile.add_card(random_card)
	character_sprite.play_pop_up("forced discard: " + str(number_of_cards), Color("b82d1d"))

func end_turn():
	my_screen.card_manager.discard_hand()
	ended_turn.emit(self)

func start_turn():
	my_screen.card_manager.turn_start_draw()
	started_turn.emit(self)
	
func _process(_delta: float) -> void:
	if pis_machine.current_state == Model.InputState.MOVE:
		_handle_input()

func drop_queued_loot_cards():
	#when player discards loot cards they are put in a queue which is emptied onto a tile the player exits
	if queued_drop_cards.is_empty() == false:
		var drop_tile:Tile = Utils.try_get_grid_man().floor_maps[current_floor][grid_coordinates.x][grid_coordinates.y]
		#if no 'card pile' grid_sprite exists on the tile one will be created to contain these dropped cards
		for each_card in queued_drop_cards:
			my_screen.card_manager.remove_card(each_card)
			each_card.owning_character = null
			drop_tile.add_grid_card(each_card)
	queued_drop_cards.clear()

func move(new_grid_position:Vector2, new_screen_position:Vector2):
	#the exit and enter part of the movement occurs in grid manager
	#this is just the character updating its information and visual position as a result of that movement
	var old_grid_position = grid_coordinates
	grid_coordinates = new_grid_position
	movement -= 1
	character_sprite.position = new_screen_position
	Events.character_moved.emit(self, old_grid_position, new_grid_position)
	moved.emit(self, old_grid_position, new_grid_position)
	
func _handle_input():
	#allows character to move if in the correct PISM state
	#character signals to grid manager that it wants to move, grid manager checks if move is valid and then
	#does 'move_object' on the character sprite, which then also calls 'move' above
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
	#used when in targetting mode to check which card is actively doing the targetting
	return my_screen.card_manager.card_being_played
#endregion


#region Signal Functions
func _on_state_machine_switched(old_state:String, new_state:String):
	if new_state == Model.InputState.CURSOR or old_state == Model.InputState.CURSOR or new_state == Model.InputState.TARGET || old_state == Model.InputState.TARGET:
		#if the new or old state are CURSOR or TARGETTING we want to flip the visibility of the cursor
		#and move the cursor to the characters location
		cursor_sprite.move(grid_coordinates, character_sprite.position)
		cursor_sprite.toggle_visibility()
		if cursor_sprite.visible == true:
			#sets the camera to follow the cursor sprite when its visible
			cursor_sprite.set_remote_camera_transform(my_screen.player_sub_viewport.camera)
		else:
			#otherwise camera follows the character sprite
			character_sprite.set_remote_camera_transform(my_screen.player_sub_viewport.camera)
			
	if new_state == Model.InputState.TARGET:
		#when switching to target state we want to highlight tiles the card can target
		Utils.try_get_grid_man().highlight_targettable_tiles(get_my_current_playing_card(), grid_coordinates, 0)
		
	if old_state == Model.InputState.TARGET:
		#and when exiting target state we want those highlights cleared
		Utils.try_get_grid_man().clear_highlights(character_id, 0)


func _on_looted_card(_character:Character):
	if _character == self:
		#plays pop up when player picks up a card :)
		character_sprite.play_pop_up("Looted", Color("#d4ff3b"))
#endregion
