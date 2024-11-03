extends State

@export var gun: Gun

const DashTimeout = 0.5
var dashTimeLeft

func enter(last_state: State = null) -> void:
	pass

func exit() -> void:
	pass

func update(delta: float) -> void:
	if Input.is_action_just_pressed("swap weapon"):
		emit_signal("transition", "SwordState", self)
	if Input.is_action_pressed("attack"):
		gun.shoot()
