extends CharacterBody2D
class_name CannonEnemy

signal enemy_died

func _ready():
	add_to_group("Enemy")

func _physics_process(delta: float) -> void:
	move_and_slide()


@onready var hc = get_node("HealthComponent")
@onready var healthBar: HealthBar = $HealthBar
func _on_health_component_died() -> void:
	print("Canon enemy has died")
	emit_signal("enemy_died")
	queue_free()


func _on_health_component_health_changed(current_health: int) -> void:
	healthBar.setPercent(100*current_health/hc.max_health)