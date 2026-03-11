class_name Card
extends Control

enum target_types{caster, character, explored_tile, unexplored_tile}

#region Signals
signal clicked()
signal activate_effect(which_card)
#endregion


#region Properties
@export var cost: Dictionary[ValueManager.CreatureValue, int] = {}
@export var description: String = "Placeholder Description"
@export var character_sprite: CharacterSprite
@export var deck: Deck = null
@export var pile: Pile = null
var is_faceup: bool = true
var targets: Dictionary[Node, target_types]
var targets_required: Dictionary[target_types, int]

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
		var letter = ValueManager.value_names[cv][0]
		var label: Label = Label.new()
		label.text = "{0}{1}".format([cost[cv], letter])
		label.add_theme_color_override("font_color", Color.BLACK)
		_costs_hbox.add_child(label)
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


func play() -> void:
	#making value manager instance for testing
	var testing_value_manager = ValueManager.new()
	#check for values, then reserve them
	if testing_value_manager.check_values(cost.keys().pick_random(), 0, self) == true:
		pass
		#check if targetting is needed by the card
		if targets_required.has(target_types.caster) == true:
			#no targetting needed, only affects caster. some other types may not require targetting and can be added here
			#play card effect
			_trigger_play_ability()
		else:
			#call state machine to switch to 'targetting' state, pass it this card so it knows what is targetting
			Events.request_input_state_transition.emit(Model.InputState.TARGET, owning_character)
	else:
		pass
		#make card play 'cant be played' animation or sound

func validate_targets():
	#called from the card manager? cursor? when the player selects the last (or only) target in targetting mode
	if targets_required.size() != targets.size():
		#verifying that player hasn't selected too few or too many targets
		targets.clear() #so they can start over
		return false #stay in targetting mode, indicate player to re-pick targets
	var approved_targets: Dictionary[target_types, int]
	#check each target type that is required to see if the right number of each have been provided
	for each_target_type in targets_required.keys():
		for each_node_type in targets.keys():
			if approved_targets.has(each_node_type) == true:
				approved_targets[each_node_type] += 1
			else:
				approved_targets[each_node_type] = 1
	#checks that the 'approved targets' dictionary created above by counting types of targets in 'targets'
	#matches the required targets
	if targets_required.recursive_equal(approved_targets, 1) == true:
		Events.request_input_state_transition.emit(Model.InputState.CARD, owning_character)
		return true
		_trigger_play_ability()
	else:
		return false #stay in targetting mode, indicate player to re-pick targets

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
	targets[owning_character] = target_types.caster
	owning_character.movement += 3
	Events.card_played.emit(self) #then tell value manager to unreserve+spend the values this card reserved
	

func _trigger_discard_ability() -> void:
	targets[owning_character] = target_types.caster
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
