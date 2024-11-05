extends State

@export var sword: Sword

func enter(last_state: State = null) -> void:
	pass

func exit() -> void:
	pass

func update(delta: float) -> void:
	if Input.is_action_pressed("attack"):
		sword.slash()
	if Input.is_action_just_pressed("swap weapon"):
		emit_signal("transition", "CannonState", self)
