class_name Character extends Node2D

#region signals
signal health_changed(which_player, old_value, new_value)
signal moved(which_player, old_coord, new_coord)
signal died(which_player)
signal ended_turn(which_player)
signal started_turn(which_player)
#endregion

#region properties
var input_man:PlayerInputManager
var pis_machine:PlayerInputStateMachine
var controller_id:int #will this be an int??
var character_id:int
var health_max:int = 5
var health_current:int
var deck:Deck
var grid_coordinates:Vector2
	#get():
		#return character_sprite.grid_coordinates
var movement:int
var character_sprite:CharacterSprite
var cursor_sprite:CursorSprite
#endregion

#region methods
func setup_new_character(input_character_id:int) -> Character:
	character_id = input_character_id
	input_man = InputManager.get_player_input_manager(character_id)
	return self

func bind_controller(controller_info:int):
	controller_id = controller_info
	
func bind_character_sprite(input_sprite:CharacterSprite):
	character_sprite = input_sprite
	character_sprite.input_man = input_man
	character_sprite.input_state_machine = pis_machine
	add_child(character_sprite)
	
func bind_cursor_sprite(input_sprite:CursorSprite):
	cursor_sprite = input_sprite
	cursor_sprite.input_man = input_man
	cursor_sprite.input_state_machine = pis_machine
	add_child(cursor_sprite)

func bind_deck(new_deck:Deck):
	deck = new_deck
	add_child(deck)

func bind_pis_machine(input_pis_machine:PlayerInputStateMachine):
	pis_machine = input_pis_machine
	pis_machine.character_sprite = character_sprite
	pis_machine.owner = self

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
	
#func move(new_coordinates):
	#var old_coords = coordinates
	#coordinates = new_coordinates
	#moved.emit(self, old_coords, new_coordinates)
	
	
func end_turn():
	ended_turn.emit(self)

func start_turn():
	started_turn.emit(self)
#endregion
