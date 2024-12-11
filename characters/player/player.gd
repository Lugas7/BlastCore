extends CharacterBody2D
class_name Player

var gold = 0

var xinput = 0
var yinput = 0
var xdir = 0
var ydir = 0

const damageTimeout = 0.5
var damageTimeoutLeft = 0

const upgradeList = preload("res://upgradeList.gd").UpgradeList

var upgrades: Dictionary

@onready var movementStateMachine = get_node("Movement State machine")
@onready var attacktStateMachine = get_node("Attack State machine")

func _ready() -> void:
	gold = 110
		
@onready var healthBar: HealthBar = $HealthBar
@onready var hc: HealthComponent = $HealthComponent

func _physics_process(_delta: float) -> void:
	if damageTimeoutLeft > 0:
		damageTimeoutLeft -= _delta
	else:
		hc.set_invincible(false)
		damageTimeoutLeft = damageTimeout
		
	move_and_slide()

# sets the velocity for characterBody2D after updating direction
func setSpeed(speed):
	updateDirection()
	velocity.x = speed * xdir
	velocity.y = speed * ydir

# updates the direction variables xdir and ydir based on user input (w,a,s,d)
func updateDirection():
	xinput = Input.get_axis("ui_left", "ui_right")
	yinput = Input.get_axis("ui_up", "ui_down")
	
	if xinput != 0 and yinput != 0:
		var dir = atan2(yinput, xinput)
		xdir = cos(dir)
		ydir = sin(dir)	
	else:
		xdir = xinput
		ydir = yinput
		
	




# runs after the health components health reaches 0
func _on_health_component_died() -> void:
	queue_free()

# runs after health components health is modified, usually by reduction
func _on_health_component_health_changed(current_health: int) -> void:
	healthBar.setPercent(100*current_health/hc.max_health)
	hc.set_invincible(true)
	damageTimeoutLeft = damageTimeout
