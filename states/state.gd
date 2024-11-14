extends Node
class_name State

signal transition(state_name: String, last_state: State)

func enter(last_state: State = null) -> void:
	pass

func exit() -> void:
	pass

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	pass
