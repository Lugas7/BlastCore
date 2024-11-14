extends State

@export var player: Player

const DASHSPEED = 1600
const dashTime = 0.3
const DashTimeout = 0.5
var dashTimeLeft

func enter(last_state: State = null) -> void:
	player.setSpeed(DASHSPEED)
	dashTimeLeft = dashTime

func exit() -> void:
	pass

func update(delta: float) -> void:
	if dashTimeLeft > 0:
		dashTimeLeft -= delta
	else:
		emit_signal("transition", "WalkState", self)
