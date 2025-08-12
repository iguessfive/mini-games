class_name CallableStateMachine extends RefCounted

enum {
	ENTER,
	UPDATE,
	EXIT
}

var state_collection: Dictionary[Variant, Dictionary] = {}
var active_state: Variant

func add_state(
	state_name: Variant,
	enter_state_callable: Callable,
	update_state_callable: Callable,
	exit_state_callable: Callable
) -> void:
	var state_data: Dictionary[int, Callable] = {
		ENTER: enter_state_callable,
		UPDATE: update_state_callable,
		EXIT: exit_state_callable
	}
	state_collection[state_name] = state_data


func set_initial_state(state_name: Variant) -> void:
	if state_collection.has(state_name):
		_set_state(state_name)
	else:
		push_warning("No state with name " + state_name)


func update() -> void:
	if (
		active_state != null # on a state
		and state_collection.has(active_state) # has state
		and state_collection[active_state][UPDATE] != Callable() # has an update callable
	):
		(state_collection[active_state][UPDATE]).call()


func change_state(state_name: Variant) -> void:
	if state_collection.has(state_name):
		_set_state.call_deferred(state_name)
	else:
		push_warning("No state with name " + state_name)


# Internal
func _set_state(state_name: Variant) -> void:
	if active_state != null:
		var exit_callable = state_collection[active_state][EXIT]
		if !exit_callable.is_null():
			exit_callable.call()
	
	active_state = state_name
	
	var enter_callable = state_collection[active_state][ENTER]
	if !enter_callable.is_null():
		enter_callable.call()
