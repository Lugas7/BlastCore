extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var bounce = false
var bouncesLeft = 2

func _physics_process(_delta: float) -> void:
	var col = move_and_collide(velocity * _delta)
	
	if col:
		print(col.get_collider())
		var object = col.get_collider()
		var isPlayer = object && object.is_in_group("Player")
		
		# Bounce if it has bounced less than twice and the collision object is not the player
		if bounce && bouncesLeft > 0 && !isPlayer:
			var normal = col.get_normal()
			velocity = velocity.bounce(normal)
			
			bouncesLeft -= 1
		else:
			queue_free()
		


func _on_simple_damage_area_damage_dealt() -> void:
	queue_free()
