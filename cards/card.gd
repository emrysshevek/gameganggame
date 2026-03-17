class_name Card
extends Control

#region Signals
signal clicked()
signal activate_effect(which_card)
#endregion


#region Properties
@export var cost: Dictionary[Model.CreatureValue, int] = {}
@export var description: String = "Placeholder Description"
@export var character_sprite: CharacterSprite
@export var deck: Deck = null
@export var pile: Pile = null
var is_faceup: bool = true
var targets: Dictionary[Node, Model.ObjectTypes]
var targets_required: Dictionary[Model.ObjectTypes, int]
@onready var target_range_max:int = 3 #set to 0 to auto-target own character or tile

@export var focus: Focusable

@export var _backside: Node
@export var _frontside: Node
@export var _description_label: Label
@export var _costs_hbox: HBoxContainer

var owning_character:Character #should change this to a reference to the character later
#endregion


#region Godot Built-in Methods
func _ready() -> void:
	_description_label.text = description
	if is_faceup:
		_frontside.show()
		_backside.hide()
	else:
		_frontside.hide()
		_backside.show()
		
	for cv in cost.keys():
		var letter = Model.CreatureValue.keys()[cv].left(1)
		var label: Label = Label.new()
		label.text = "{0}{1}".format([cost[cv], letter])
		label.add_theme_color_override("font_color", Color.BLACK)
		_costs_hbox.add_child(label)
		
	#testing
	targets_required[Model.ObjectTypes.TILE] = 1
#endregion


#region Public Methods
func flip() -> void:
	if is_faceup:
		_frontside.hide()
		_backside.show()
	else:
		_frontside.show()
		_backside.hide()
	is_faceup = !is_faceup	

func value_check() -> bool:
	var value_man = Utils.try_get_value_manager()
	#check for values, then reserve them
	for each_value_type in cost.keys():
		if value_man.get_value(each_value_type) >= cost[each_value_type]:
			pass
		else:
			return false
			#make card play 'cant be played' animation or sound
	for each_value_type in cost.keys():
		value_man.reserve_value(each_value_type, cost[each_value_type])
	return true

func play() -> void:
	targets.clear()
	#check if targetting is needed by the card
	if targets_required.has(Model.ObjectTypes.PLAYER_CHARACTER) == true && target_range_max == 0:
		#no targetting needed, only affects caster. some other types may not require targetting and can be added here
		#play card effect
		_trigger_play_ability()
	else:
		#call state machine to switch to 'targetting' state, pass it card owner so events knows who is calling for switch
		Events.request_input_state_transition.emit(Model.InputState.TARGET, owning_character)

func validate_target(potential_target:Tile, just_checking:bool) -> bool: #overwrite(?) this for sub-class cards
	#called from the cursor when the player selects a target with the cursor in TARGET state
	#the OBJECT_TYPE of the target is already checked by the tile, but not necessarily target_type
	if potential_target.is_tile_revealed == false:
		if just_checking == false:
			targets[potential_target] = Model.ObjectTypes.TILE
		return true
	return false

func check_targetting_finished():
	if targets_required.size() > targets.size():
		pass #stay in targetting mode, indicate player to continue pickig targets
	elif targets_required.size() < targets.size():
		#verifying that player hasn't selected too many targets
		targets.clear() #so they can start over
		pass #stay in targetting mode, indicate player to re-pick targets
	#var approved_targets: Dictionary[Model.ObjectTypes, int]
	##check each target type that is required to see if the right number of each have been provided
	#for each_target_type in targets_required.keys():
		#for each_node_type in targets.values():
			#if approved_targets.has(each_node_type) == true:
				#approved_targets[each_node_type] += 1
			#else:
				#approved_targets[each_node_type] = 1
	#checks that the 'approved targets' dictionary created above by counting types of targets in 'targets'
	#matches the required targets
	if targets_required.recursive_equal(translate_targets(), 1) == true:
		Events.request_input_state_transition.emit(Model.InputState.CARD, owning_character)
		_trigger_play_ability()
	else:
		print ("somehow player picked invalid targets")
		assert(false)

func translate_targets() -> Dictionary[Model.ObjectTypes, int]:
	#returns a dictionary of all current targets that matches the formatting of 'targets_required' for comparison
	var translated_target_dictionary:Dictionary[Model.ObjectTypes, int]
	for each_target_type in targets_required.keys():
		for each_node_type in targets.values():
			if translated_target_dictionary.has(each_node_type) == true:
				translated_target_dictionary[each_node_type] += 1
			else:
				translated_target_dictionary[each_node_type] = 1
	return translated_target_dictionary

func get_my_target_types():
	return targets_required.keys()
	
func get_remaining_target_types() -> Array[Model.ObjectTypes]:
	var return_types:Array[Model.ObjectTypes]
	var translated_current_targets = translate_targets()
	for each_required_type in targets_required.keys():
		if translated_current_targets.has(each_required_type) == true:
			if targets_required[each_required_type] == translated_current_targets[each_required_type]:
				pass
			else:
				return_types.append(each_required_type)
		else:
			return_types.append(each_required_type)
	#for each_required_type in targets_required.keys():
		#if targets.values().has(each_required_type):
			#if targets[each_required_type] == targets_required[each_required_type]:
				#pass
			#elif targets[each_required_type] > targets_required[each_required_type]:
				#print("too many targets selected")
				#assert(false)
			#elif targets[each_required_type] < targets_required[each_required_type]:
				#print("more targets needed")
				#return_types.append(each_required_type)
		#else:
			#return_types.append(each_required_type)
	return return_types

func discard() -> void:
	_trigger_discard_ability()
	Events.card_discarded.emit(self)
	
func highlight_react() -> void:
	scale = Vector2(1.5, 1.5)
	
func highlight_return():
	scale = Vector2(1,1)
#endregion


#region Private Methods
func _trigger_play_ability() -> void:
	#targets[owning_character] = target_types.caster
	#owning_character.movement += 3
	targets.keys()[0].reveal(owning_character.character_id)
	for each_value_type in cost.keys():
		Utils.try_get_value_manager().use_reserved_value(each_value_type, cost[each_value_type])
	Events.card_played.emit(self) #then tell value manager to unreserve+spend the values this card reserved
	

func _trigger_discard_ability() -> void:
	#targets[owning_character] = target_types.caster
	owning_character.movement += 1
#endregion


#region Signal Connections
func _on_button_pressed() -> void:
	play()
	clicked.emit()
	
	
func _on_focus_entered() -> void:
	pass
	
	
func _on_focus_exited() -> void:
	pass
#endregion
