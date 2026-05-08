extends Node2D


var won := true


func _ready() -> void:
	if won:
		$WinLabel.show()
		$LoseLabel.hide()
	else:
		$WinLabel.hide()
		$LoseLabel.show()


func _input(event: InputEvent) -> void:
	if event.is_action_released("select"):
		get_tree().change_scene_to_file("res://scenes/title/title_screen.tscn")
