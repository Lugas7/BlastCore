extends CharacterBody2D
class_name SwirlEnemy

#const SPEED = 300.0


func _physics_process(delta: float) -> void:
	move_and_slide()
