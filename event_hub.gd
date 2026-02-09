# EventHub autoload
extends Node


#region Properties
## Mapping from event type to handler method.
var _event_handlers = {
	Model.Event.CREATURE_VALUE_DECREASED: _on_creature_value_decreased,
	Model.Event.CREATURE_VALUE_INCREASED: _on_creature_value_increased,
}


## Mapping from an event type to its subscribers and their callbacks.
var _event_subscribers = {}
#endregion


#region Methods
## Registers the signal to the specified event. All subscribers to this
## event will be called when the registered signal is emitted.
func register(event_type: Model.Event, _signal: Signal) -> void:
	_signal.connect(_event_handlers[event_type])


## Subscribes the caller to the specified event. The provided callback
## method will be executed every time the signal is emitted.
func subscribe(event_type: Model.Event, callback: Callable) -> void:
	if _event_subscribers.has(event_type):
		_event_subscribers[event_type].append(callback)
	else:
		_event_subscribers[event_type] = [callback]


## Calls all the subscribers to the CREATURE_VALUE_DECREASED event.
func _on_creature_value_decreased(value_type: Model.CreatureValue, quantity: int) -> void:
	for callback: Callable in _event_subscribers[Model.Event.CREATURE_VALUE_DECREASED]:
		callback.call(value_type, quantity)


## Calls all the subscribers to the CREATURE_VALUE_INCREASED event.
func _on_creature_value_increased(value_type: Model.CreatureValue, quantity: int) -> void:
	for callback: Callable in _event_subscribers[Model.Event.CREATURE_VALUE_INCREASED]:
		callback.call(value_type, quantity)
#endregion
