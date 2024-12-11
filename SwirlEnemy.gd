extends CharacterBody2D
class_name SwirlEnemy

#const SPEED = 300.0
@export var disableMoving = false

func _ready() -> void:
	add_to_group("Enemy")

# first checks if the enemy is disabled from moving then runs move and slide if it is not disabled
func _physics_process(delta: float) -> void:
	if !disableMoving:
		move_and_slide()

@onready var hc = get_node("HealthComponent")
@onready var healthBar: HealthBar = $HealthBar
signal enemy_died
# emits enemy_died signal when health component health reaches 0
func _on_health_component_died() -> void:
	emit_signal("enemy_died")
	#print("Canon enemy has died")
	queue_free()

# updates healthbar on change in health component
func _on_health_component_health_changed(current_health: int) -> void:
	healthBar.setPercent(100*current_health/hc.max_health)
