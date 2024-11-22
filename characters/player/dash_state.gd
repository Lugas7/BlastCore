extends State

@export var player: Player

const DASHSPEED = 1600.0
const dashTime = 0.3
const DashTimeout = 0.5

const dashLength = DASHSPEED * dashTime

const dashSpeedUpgraded = DASHSPEED * 1.6
const dashTimeUpgraded = dashLength / dashSpeedUpgraded
const dashTimeoutUpgraded = 0.35

var dashTimeLeft

func enter(last_state: State = null) -> void:
	var upgrades = get_parent().get_parent().upgrades
	
	var spd = DASHSPEED
	var time = dashTime
	var timeout = DashTimeout
	if upgrades["fast_dash"]:
		print("fast dashing")
		spd = dashSpeedUpgraded
		time = dashTimeUpgraded
		timeout = dashTimeoutUpgraded
	
	player.setSpeed(spd)
	dashTimeLeft = time

func exit() -> void:
	pass

func update(delta: float) -> void:
	if dashTimeLeft > 0:
		dashTimeLeft -= delta
	else:
		emit_signal("transition", "WalkState", self)
