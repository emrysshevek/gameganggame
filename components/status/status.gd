class_name Status

## Apply lasting effects to entities (characters, tiles, etc)
##
## To make a status:
## 1. Create a new script inheriting this one named [StatusName]Status
## 2. Override _init() with proper initial value (if needed) and status name
## 3. Override _trigger_effect with the statuses effect, and any other methods as needed
## 3. Make sure to call super when overriding (or be 100% sure that you don't need to)
## (See WellPreparedStatus.gd)
##
## To apply a status:
## 1. Make sure target entity has a StatusManager node in its scene
## 2. In the target's StatusManager, call add_status() with a new instance of your status
##    eg. `target.status_manager.add_status(MyStatus.new(3))`
## (See WellPreparedCard.gd)

signal remove_status(status: Status)

var entity: Node # the object the status is applied to
var icon: ImageTexture
var status_name: String
var value: int


## Set initial value and status name.
func _init(val: int) -> void:
	value = val


## For triggering effects when status is applied. Also use to connect to necessary signals
## If status cannot be applied, return false
func apply(target: Node) -> bool:
	entity = target
	Events.status_applied.emit(self, entity)
	return true
	

## For triggering effects when status is removed. 
## If removal is not possible, return false
func remove() -> bool:
	Events.status_removed.emit(self, entity)
	return true


## For adding to an existing status. 
## Override if there is a special way they should be combined
func update(status: Status) -> void:
	value += status.value
	Events.status_added.emit(self, entity)


## Pretty obvious imo. Remember to call `super.trigger_effect()` to maintain print logging
func trigger_effect() -> void:
	print("Triggering status effect: ", status_name)
	Events.status_triggered.emit(self, entity)
