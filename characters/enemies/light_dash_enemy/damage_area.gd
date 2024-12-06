extends Area2D

signal damage_dealt(target)

@export var damage: int = 10

func get_damage() -> int:
	emit_signal("damage_dealt", get_parent())
	return damage

func _on_area_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and get_parent().is_dashing:
		if body.has_method("take_damage"):
			body.take_damage(damage)
			print("Dealt damage: ", damage)
