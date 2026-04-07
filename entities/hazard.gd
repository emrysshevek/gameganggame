class_name Hazard extends GridSprite

func _ready() -> void:
	set_type(Model.ObjectTypes.HAZARD)
	centered = false
	set_sprite(load("res://art/hazard.png"))
	self_modulate = Color("ffff11")

func trigger_enter_ability(target:Character):
	#override from grid_sprite
	print("hazard does 2 damage")
	target.take_damage(2)
	
func trigger_exit_ability(target:Character):
	print("hazard forces 1 random discard")
	target.forced_random_discard(1)
