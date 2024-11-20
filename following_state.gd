extends State

@export var swirlEnemy: SwirlEnemy
@export var detectionZone: Area2D
@export var sword: Sword

const speed = 200
var currentAngle
func enter(last_state: State = null) -> void:
	sword.toggleSpinning()

func exit() -> void:
	sword.toggleSpinning()

func update(delta: float) -> void:
	if detectedNode:
		currentAngle = swirlEnemy.global_position.angle_to_point(detectedNode.position)
		swirlEnemy.velocity = Vector2(speed*cos(currentAngle), speed*sin(currentAngle))
	else:
		emit_signal("transition", "WanderingState", self)

var detectedNode
func NodeEnteredArea(body: Node2D):
	detectedNode = body

func NodeExitedArea(body: Node2D):
	detectedNode = null
