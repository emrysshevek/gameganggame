class_name Focusable
extends Node

signal focus_entered()
signal focus_exited()

@export_category("Focus Neighbors")
@export var up: Node
@export var down: Node
@export var left: Node
@export var right: Node
@export var next: Node
@export var prev: Node

var _focused := false
var is_focused: bool:
	get:
		return _focused


@onready var _neighbors: Dictionary[String, Node] = {
	"up": up,
	"down": down,
	"left": left,
	"right": right,
	"next": next,
	"prev": prev,
}


func shift_focus(dir: String) -> void:
	var focus_node: Focusable = _neighbors[dir].get_node("Focusable")
	assert(focus_node != null)
	exit_focus()
	focus_node.enter_focus()


func enter_focus() -> void:
	_focused = true
	focus_entered.emit()


func exit_focus() -> void:
	_focused = false
	focus_exited.emit()
