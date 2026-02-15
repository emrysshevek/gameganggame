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
