extends State

@export var enemy: CannonEnemy
@export var detectionZone: Area2D
@export var gun: Gun
#@export var sword: Sword
@export var shootingCooldownTimeInSeconds = 3

var timeBeforeNextShot = shootingCooldownTimeInSeconds
var lastBullet: CharacterBody2D

const speed = 200
var currentAngle
func enter(last_state: State = null) -> void:
	pass #sword.toggleSpinning()

func exit() -> void:
	pass #sword.toggleSpinning()

func update(delta: float) -> void:
	if detectedNode:
		currentAngle = enemy.global_position.angle_to_point(detectedNode.position)
		enemy.velocity = Vector2(speed*cos(currentAngle), speed*sin(currentAngle))

		timeBeforeNextShot -= delta
		gun.look_at(detectedNode.global_position)
		if timeBeforeNextShot <= 0:
			timeBeforeNextShot = shootingCooldownTimeInSeconds
			lastBullet = await gun.shootPlayer()
			await get_tree().create_timer(1).timeout
			teleportToLastBullet()
	else:
		emit_signal("transition", "WanderingState", self)

func teleportToLastBullet():
	if lastBullet and is_instance_valid(lastBullet):
		enemy.global_position = lastBullet.global_position
		lastBullet.queue_free()

var detectedNode
func NodeEnteredArea(body: Node2D):
	detectedNode = body

func NodeExitedArea(body: Node2D):
	detectedNode = null
