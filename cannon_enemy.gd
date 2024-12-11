extends CharacterBody2D
class_name CannonEnemy

signal enemy_died

func _ready():
	add_to_group("Enemy")

func _physics_process(delta: float) -> void:
	move_and_slide()


@onready var hc = get_node("HealthComponent")
@onready var healthBar: HealthBar = $HealthBar
# activate when health component health reaches 0, emits enemy_died signal and kills all children characters with _on_health_component_died method
func _on_health_component_died() -> void:
	emit_signal("enemy_died")
	for child in get_children():
		if child.has_method("_on_health_component_died"):
			child._on_health_component_died()
		#child.queue_free()
	queue_free()

# updates health bar on change in health component
func _on_health_component_health_changed(current_health: int) -> void:
	healthBar.setPercent(100*current_health/hc.max_health)
