## Utils autoload
extends Node


func try_get_value_manager() -> ValueManager:
	var v_list = get_tree().get_nodes_in_group(Config.VALUE_MANAGER_GROUP)
	return v_list[0] if len(v_list) > 0 else null

func try_get_grid_man() -> GridManager:
	var v_list = get_tree().get_nodes_in_group(Config.GRID_MANAGER_GROUP)
	return v_list[0] if len(v_list) > 0 else null
