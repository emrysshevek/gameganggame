class_name StatusManager
extends Node

@export var statuses: Array[Status]


func add_status(_status: Status) -> bool:
	for status in statuses:
		if _status.status_name == status.status_name:
			status.update(_status)
			return true
	
	if not _status.apply_to(owner):
		return false
		
	_status.reparent(self)
	statuses.append(statuses)
	return true


func remove_status(_status: Status) -> bool:
	for status in statuses:
		if status.status_name == _status.status_name:
			statuses.erase(status)
			status.queue_free()
			return true
	return false
