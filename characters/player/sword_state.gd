extends State

@export var sword: Sword

func enter(last_state: State = null) -> void:
	pass

func exit() -> void:
	pass

# activates slash on attack action and transitions back to dash state on swap weapon action
func update(delta: float) -> void:
	if Input.is_action_pressed("attack"):
		sword.slash()
	if Input.is_action_just_pressed("swap weapon"):
		emit_signal("transition", "CannonState", self)
