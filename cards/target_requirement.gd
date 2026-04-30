class_name TargetRequirement
extends Resource

enum TargetMode{
	CURSOR,
	PLAYER,
	CARD,
}

@export var mode := TargetMode.CURSOR
@export var type: Model.ObjectTypes
@export var min_count := 0
@export var max_count := 0
@export var min_range := 0
@export var max_range := 1000

var target_state: String:
	get:
		match mode:
			TargetMode.CURSOR:
				return Model.InputState.TARGET_CURSOR
			TargetMode.PLAYER:
				return Model.InputState.TARGET_PLAYER
			TargetMode.CARD:
				return Model.InputState.TARGET_CARD
			_:
				return ""
