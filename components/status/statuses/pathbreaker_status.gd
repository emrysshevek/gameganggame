class_name PathbreakerStatus
extends CharacterStatus


## Pathbreaker X: For next X moves, gain 1 movement when exploring a tile


func _init(val:=1) -> void:
	super._init(val)
	status_name = "Pathbreaker"
	

func apply(target: Node) -> bool:
	if not super.apply(target):
		return false

	Events.character_moved.connect(_on_character_moved)
	Events.tile_explored.connect(_on_tile_explored)
	return true


func trigger_effect() -> void:
	super.trigger_effect()
	character.movement += 1
	
	
func _on_tile_explored(_tile: Tile, _character: Character) -> void:
	if _character == character:
		trigger_effect()


func _on_character_moved(_character: Character, _old: Vector2i, _new: Vector2i) -> void:
	if _character == character:
		value -= 1
		if value == 0:
			remove_status.emit(self)
