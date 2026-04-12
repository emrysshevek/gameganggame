class_name StatusManager
extends Node

## Keeps track of statuses applied to owner (statuses handle their own triggering and effects)

var statuses: Array[Status]


## Call this to add or update a status (so the source doesn't have to know if this status is already applied)
func add_status(_status: Status) -> bool:
	for status in statuses:
		if _status.status_name == status.status_name:
			status.update(_status)
			return true

	if not _status.apply(owner):
		return false
	
	_status.remove_status.connect(remove_status)
	statuses.append(_status)
	print("added status ", _status.status_name, " to ", owner.name)
	return true


func remove_status(_status: Status) -> bool:
	print("Removing status: ", _status.status_name)
	for status in statuses:
		if status.status_name == _status.status_name:
			status.remove()
			statuses.erase(status)
			return true
	return false
