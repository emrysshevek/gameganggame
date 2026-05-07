extends Node2D

var player_count_focused := true


func _input(event: InputEvent) -> void:
	if player_count_focused and Input.is_action_just_released("move_up"):
		$PlayerCount.value += $PlayerCount.step
	elif player_count_focused and Input.is_action_just_released("move_down"):
		$PlayerCount.value -= $PlayerCount.step


func _on_player_count_value_changed(value: float) -> void:
	Config.player_count = value


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/GameScene.tscn")


func _on_player_count_focus_entered() -> void:
	player_count_focused = true


func _on_player_count_focus_exited() -> void:
	player_count_focused = false
