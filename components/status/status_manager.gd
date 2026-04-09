class_name StatusManager
extends Node

var statuses: Array[Status]


func add_status(_status: Status) -> bool:
	for status in statuses:
		if _status.status_name == status.status_name:
			status.update(_status)
			return true

	if not _status.apply(owner):
		return false

	statuses.append(_status)
	return true


func remove_status(_status: Status) -> bool:
	for status in statuses:
		if status.status_name == _status.status_name:
			status.remove()
			statuses.erase(status)
			return true
	return false
