extends CharacterBody2D
class_name SwirlEnemy

#const SPEED = 300.0


func _physics_process(delta: float) -> void:
	move_and_slide()


@onready var hc = get_node("health_component")
func _on_health_component_died() -> void:
	print("Player died")
	queue_free()


func _on_health_component_health_changed(current_health: int) -> void:
	print("Health changed: ", current_health)
