extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var bounce = false
var hasBounced = false

func _physics_process(_delta: float) -> void:
	var col = move_and_collide(velocity * _delta)
	
	if col:
		if bounce && !hasBounced:
			var normal = col.get_normal()
			velocity = velocity.bounce(normal)
			
			hasBounced = true
		else:
			queue_free()
		


func _on_simple_damage_area_damage_dealt() -> void:
	queue_free()
