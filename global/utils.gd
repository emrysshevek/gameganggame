## Utils autoload
extends Node


func value_to_string(value: Model.CreatureValue) -> String:
	return Model.CreatureValue.keys()[value]


func get_random_value() -> Model.CreatureValue:
	return randi() % len(Model.CreatureValue) as Model.CreatureValue


func try_get_value_manager() -> ValueManager:
	var v_list = get_tree().get_nodes_in_group(Config.VALUE_MANAGER_GROUP)
	return v_list[0] if len(v_list) > 0 else null


func try_get_grid_man() -> GridManager:
	var v_list = get_tree().get_nodes_in_group(Config.GRID_MANAGER_GROUP)
	return v_list[0] if len(v_list) > 0 else null


func try_get_game_scene() -> GameScene:
	var v_list = get_tree().get_nodes_in_group(Config.GAME_SCENE_GROUP)
	return v_list[0] if len(v_list) > 0 else null
