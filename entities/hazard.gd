class_name Hazard extends GridSprite

var block_trigger := false

func _ready() -> void:
	set_type(Model.ObjectTypes.HAZARD)
	centered = false
	set_sprite(load("res://art/hazard.png"))
	self_modulate = Color("ffff11")

func trigger_enter_ability(target:Character):
	Events.hazard_will_trigger.emit(self, target)
	if block_trigger:
		block_trigger = false
		return
	
	print("hazard deals 2 damage")
	var damage = 2
	target.take_damage(damage)
	Events.character_damaged.emit(target, damage, self)
	
func trigger_exit_ability(target:Character):
	Events.hazard_will_trigger.emit(self, target)
	if block_trigger:
		block_trigger = false
		return

	print("hazard forces 1 random discard")
	target.forced_random_discard(1)
	Events.forced_discard.emit(target, self)
