## Model autoload
extends Node


## Cardinal directions.
enum Direction {
	NONE,
	LEFT,
	RIGHT,
	UP,
	DOWN,
}


## Creature values.
enum CreatureValue {
	ADAPTABILITY,
	BRAVERY,
	CURIOSITY,
	DEPENDABILITY,
	EMPATHY
}

## Object Types.
enum ObjectTypes {
	TILE,
	PLAYER_CHARACTER,
	HAZARD,
}

enum CullingLayers {
	VISIBLE_ALL,
	VISIBLE_MINIMAP_ONLY,
	VISIBLE_P1_ONLY,
	VISIBLE_P2_ONLY,
	VISIBLE_P3_ONLY,
	VISIBLE_P4_ONLY,
}

## Action StringNames. These should be a 1:1 mapping to the actions defined in
## the InputMap. Always reference actions through this class to ensure
## consistency and make modifications easier in the future.
class Action:
	const MOVE_LEFT = "move_left"
	const MOVE_RIGHT = "move_right"
	const MOVE_UP = "move_up"
	const MOVE_DOWN = "move_down"
	const SELECT = "select"
	const DESELECT = "deselect"
	const TOGGLE_MAP = "toggle_map"
	const TOGGLE_CURSOR = "toggle_cursor"
	const TOGGLE_END_TURN = "toggle_end_turn"
	const DISCARD = "discard"

class InputState:
	const MOVE = "Move"
	const CARD = "Card"
	const CURSOR = "Cursor"
	const END = "End"
	const TARGET = "Target"
