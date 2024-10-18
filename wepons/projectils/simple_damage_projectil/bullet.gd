extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(_delta: float) -> void:
	move_and_slide()


func _on_simple_damage_area_damage_dealt() -> void:
	queue_free()
