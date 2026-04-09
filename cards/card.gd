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

@export var targets_required: TargetRequirement = null
var targets: Array[Node]

var is_faceup: bool = true


@export var focus: Focusable

@export var _backside: Node
@export var _frontside: Node
@export var _description_label: Label
@export var _costs_hbox: HBoxContainer
@export var _background_rect: ColorRect

var owning_character:Character
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
	#targets_required[Model.ObjectTypes.TILE] = 1
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
			fail_to_play()
			return false
	for each_value_type in cost.keys():
		value_man.reserve_value(each_value_type, cost[each_value_type])
	return true


func discard() -> void:
	_trigger_discard_ability()
	Events.card_discarded.emit(self)

func play() -> void:
	#check if targetting is needed by the card
	if targets_required == null:
		#no targetting needed, only affects caster. some other types may not require targetting and can be added here
		#play card effect
		_trigger_play_ability()
	else:
		targets.clear()
		#call state machine to switch to 'targetting' state, pass it card owner so events knows who is calling for switch
		Events.request_input_state_transition.emit(Model.InputState.TARGET, owning_character)


func try_add_target(potential_target: Node) -> bool:
	if not validate_target(potential_target):
		return false
		
	targets.append(potential_target)
	check_targetting_finished()
	return true
	

func validate_target(potential_target: Node) -> bool: 
	# Overwrite this for sub-class cards
	# Called from grid_man when trying to find tiles to highlight

	if targets.size() >= targets_required.max_count:
		return false
	
	if not("types" in potential_target and targets_required.type in potential_target.types):
		return false
		
	var owners_location = owning_character.grid_coordinates
	var distance:int = Utils.try_get_grid_man().get_crow_flies_distance(potential_target.grid_coordinates, owners_location)
	if distance > targets_required.max_range or distance < targets_required.min_range:
		return false
		
	return true
	

func check_targetting_finished():
	if targets.size() == targets_required.min_count:
		Events.request_input_state_transition.emit(Model.InputState.CARD, owning_character)
		_trigger_play_ability()


func get_my_target_types():
	return targets_required.keys()
	

	

func highlight_react() -> void:
	scale = Vector2(1.5, 1.5)
	
	
func highlight_return():
	scale = Vector2(1,1)
	
func fail_to_play():
	var new_tween = self.create_tween()
	new_tween.tween_property(self, "rotation_degrees", 15, Config.animation_speed * 0.1)
	new_tween.parallel().tween_property(_frontside, "self_modulate", Color("#b82d1d"), Config.animation_speed * 0.1)
	new_tween.tween_property(self, "rotation_degrees", -15, Config.animation_speed * 0.1)
	new_tween.parallel().tween_property(_frontside, "self_modulate", Color("#ffffff"), Config.animation_speed * 0.1)
	new_tween.tween_property(self, "rotation_degrees", 0, Config.animation_speed * 0.1)
#endregion

#region Private Methods
func _trigger_play_ability() -> void:
	for each_value_type in cost.keys():
		Utils.try_get_value_manager().use_reserved_value(each_value_type, cost[each_value_type])
	Events.card_played.emit(self) #then tell value manager to unreserve+spend the values this card reserved
	

func _trigger_discard_ability() -> void:
	owning_character.movement += 1
#endregion


#region Signal Connections
func _on_button_pressed() -> void:
	pass
	
	
func _on_focus_entered() -> void:
	pass
	
	
func _on_focus_exited() -> void:
	pass
#endregion
