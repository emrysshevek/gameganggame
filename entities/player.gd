class_name player extends Node2D

#region signals
signal health_changed(which_player, old_value, new_value)
signal moved(which_player, old_coord, new_coord)
signal died(which_player)
signal ended_turn(which_player)
signal started_turn(which_player)
#endregion

#region properties
var controller_id:int #will this be an int??
var health_max:int = 5
var health_current:int
var deck:Deck
var coordinates:Vector2
#endregion

#region methods
func bind_controller(controller_info:int):
	controller_id = controller_info

func bind_deck(new_deck:Deck):
	deck = new_deck

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
	
func move(new_coordinates):
	var old_coords = coordinates
	coordinates = new_coordinates
	moved.emit(self, old_coords, new_coordinates)
	
	
func end_turn():
	ended_turn.emit(self)

func start_turn():
	started_turn.emit(self)
#endregion
