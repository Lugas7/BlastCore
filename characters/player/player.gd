extends CharacterBody2D
class_name Player

var gold = 0

var xinput = 0
var yinput = 0
var xdir = 0
var ydir = 0

const damageTimeout = 0.5
var damageTimeoutLeft = 0

var hc: HealthComponent

const upgradeList = preload("res://upgradeList.gd").UpgradeList

var upgrades: Dictionary

@onready var movementStateMachine = get_node("Movement State machine")
@onready var attacktStateMachine = get_node("Attack State machine")

#@onready var hc: HealthComponent = get_node("HealthComponent")
func _ready() -> void:
	gold = 110
	hc = get_node("HealthComponent")
	
	for u in upgradeList:
		upgrades[u] = false
		
	#upgrades["fast_bullets"] = true
	#upgrades["fast_shot"] = true
	#upgrades["big_bullets"] = true
	#upgrades["bullet_bounce"] = true
	#upgrades["fast_swing"] = true
	#upgrades["big_sword"] = true
	#upgrades["fast_dash"] = true

func _physics_process(_delta: float) -> void:
	if damageTimeoutLeft > 0:
		damageTimeoutLeft -= _delta
		hc.set_invincible(damageTimeoutLeft <= 0)
	else:
		hc.set_invincible(false)
		damageTimeoutLeft = damageTimeout
		
	move_and_slide()

func setSpeed(speed):
	updateDirection()
	velocity.x = speed * xdir
	velocity.y = speed * ydir

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
		
	


func _on_health_component_died() -> void:
	print("Enemy died")
	queue_free()


func _on_health_component_health_changed(current_health: int) -> void:
	hc.set_invincible(true)
	damageTimeoutLeft = damageTimeout
	print("Health changed For the player!!!!!! HERE!!!!!: ", current_health)
