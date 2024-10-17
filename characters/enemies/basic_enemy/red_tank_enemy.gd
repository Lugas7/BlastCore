extends CharacterBody2D

var speed = 150
var player = null
var player_chase = false
var player_left = true



func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	if player_chase:
		var direction = (player.position - position).normalized()
		player_left = direction.x < 0
		position += direction * speed * _delta
		$AnimatedSprite2D.play("left movement")
		$AnimatedSprite2D.flip_h = !player_left

func _on_area_2d_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	player = body
	player_chase = false




func _on_health_component_died() -> void:
	print("Enemy died")
	queue_free()


func _on_health_component_health_changed(current_health: int) -> void:
	print("Health changed: ", current_health)
	
	
