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

class Action:
	const MOVE_LEFT = "move_left"
	const MOVE_RIGHT = "move_right"
	const MOVE_UP = "move_up"
	const MOVE_DOWN = "move_down"
	const SELECT = "select"
	const DESELECT = "deselect"
	const TOGGLE_MAP = "toggle_map"
