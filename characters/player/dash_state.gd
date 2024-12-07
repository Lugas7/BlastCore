extends State

@export var player: Player

# Unupgraded values
const dashSpeed_d = 1600.0
const dashTime_d = 0.3
const dashTimeout_d = 0.5

const dashLength = dashSpeed_d * dashTime_d

# Upgraded values
const dashSpeed_u = dashSpeed_d * 1.6
const dashTime_u = dashLength / dashSpeed_u
const dashTimeout_u = 0.35

var dashSpeed = dashSpeed_d
var dashTime = dashTime_d
var dashTimeout = dashTimeout_d

var dashTimeLeft

func enter(last_state: State = null) -> void:	
	player.setSpeed(dashSpeed)
	dashTimeLeft = dashTime

func exit() -> void:
	pass

func update(delta: float) -> void:
	if dashTimeLeft > 0:
		dashTimeLeft -= delta
	else:
		emit_signal("transition", "WalkState", self)
