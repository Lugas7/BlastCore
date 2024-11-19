extends State

@export var swirlEnemy: SwirlEnemy

const speed = 100
const wanderTime = 2
var wanderTimeLeft = 0
var currentAngle
func enter(last_state: State = null) -> void:
	wanderTimeLeft = 0

func exit() -> void:
	pass

func update(delta: float) -> void:
	wanderTimeLeft -= delta
	if wanderTimeLeft <= 0:
		currentAngle = randomDirection()
		wanderTimeLeft = wanderTime
		swirlEnemy.velocity = Vector2(speed*cos(currentAngle), speed*sin(currentAngle))

func NodeEnteredDetection(body: Node2D):
	emit_signal("transition", "FollowingState", self)

var rng = RandomNumberGenerator.new()
# gets a random angle in radians
func randomDirection():
	return deg_to_rad(rng.randf_range(0.0, 360.0))
