class_name LuckyLookStatus
extends CharacterStatus

## Luck Look X: For next X moves, if you explore a tile, gain 1 extra value

var tile: Tile

func _init(val:int) -> void:
	status_name = "Lucky Look"
	value = val


func apply(target: Node) -> bool:
	if not super.apply(target):
		return false
	
	Events.tile_explored.connect(_on_tile_explored)
	Events.character_moved.connect(_on_character_moved)
	return true
	
	
func trigger_effect() -> void:
	var value_manager := Utils.try_get_value_manager()
	value_manager.gain_value(tile.explore_value)
	super.trigger_effect()
	
	
func _on_tile_explored(tile: Tile, character: Character) -> void:
	if character == self.character:
		self.tile = tile
		trigger_effect()
		

func _on_character_moved(character: Character, _old, _new) -> void:
	if character == self.character:
		value -= 1
		if value <= 0:
			remove_status.emit.call_deferred(self)
