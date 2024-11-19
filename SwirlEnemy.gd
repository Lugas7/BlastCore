extends CharacterBody2D
class_name SwirlEnemy

#const SPEED = 300.0

func _ready() -> void:
	add_to_group("Enemy")

func _physics_process(delta: float) -> void:
	move_and_slide()


@onready var hc = get_node("health_component")
signal enemy_died
func _on_health_component_died() -> void:
	emit_signal("enemy_died")
	print("Player died")
	queue_free()


func _on_health_component_health_changed(current_health: int) -> void:
	print("Health changed: ", current_health)
