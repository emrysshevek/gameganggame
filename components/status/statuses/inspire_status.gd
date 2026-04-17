extends CharacterStatus

var _card: Card
var _card_costs: Dictionary[Model.CreatureValue, int]


func _init(val:int=1) -> void:
	value = val
	status_name = "Inspire"


func apply(target: Node) -> bool:
	if not super.apply(target):
		return false
	
	Events.value_reserve_attempt.connect(_on_value_reserve_attempted)
	return true
	
	
func trigger_effect() -> void:
	for key in _card_costs.keys():
		_card_costs[key] = 0
	
	value -= 1
	if value == 0:
		remove_status.emit(self)
	


func _on_value_reserve_attempted(card: Card, costs: Dictionary[Model.CreatureValue, int]) -> void:
	if not card.owning_character == character:
		return
	
	_card = card
	_card_costs = costs
		
	trigger_effect()
