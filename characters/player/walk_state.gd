extends State

@export var player: Player
const SPEED = 500.0


func enter(last_state: State = null) -> void:
	pass

func exit() -> void:
	pass

func update(delta: float) -> void:
	pass

# handles updating player moving direction and speed as well as the transition to dash state
func physics_update(delta: float) -> void:
	player.updateDirection()
	player.velocity.x = SPEED * player.xdir
	player.velocity.y = SPEED * player.ydir
	if Input.is_action_just_pressed("ui_dash"):
		emit_signal("transition", "DashState", self)
