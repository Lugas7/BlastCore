extends State
class_name CannonState

@export var gun: Gun
@export var player: Player

@export var DashTimeout = 0.5
var dashTimeLeft

@export var shootCooldown = 0.3 
var shootCooldownLeft = shootCooldown

func enter(last_state: State = null) -> void:
	gun.visible = true

func exit() -> void:
	gun.visible = false

func update(delta: float) -> void:
	shootCooldownLeft -= delta
	gun.look_at(player.get_global_mouse_position())
	if Input.is_action_just_pressed("swap weapon"):
		emit_signal("transition", "SwordState", self)
	if Input.is_action_pressed("attack") and shootCooldownLeft <= 0:
		gun.shoot()
		shootCooldownLeft = shootCooldown
