extends Node
class_name StateMachine

@export var initial_state: State

var current_state: State
var states: Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.get_name().to_lower()] = child
			child.transition.connect(_on_state_transition)
	
	initial_state.enter()
	current_state = initial_state

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)


func _on_state_transition(state_name: String, last_state: State) -> void:
	if current_state:
		current_state.exit()

	current_state = states[state_name.to_lower()]
	if current_state:
		current_state.enter(last_state)
