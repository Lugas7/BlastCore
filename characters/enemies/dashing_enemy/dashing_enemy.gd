extends MovementCharacterBody2D

var player = null
var player_chase = false
var player_left = true

@export var wait_time: float = 2.0
@export var dash_time: float = 1.0
@export var dash_acceleration_multiplyer: float = 5.0
@export var dash_max_speed_multiplyer: float = 3.0


func _physics_process(_delta: float) -> void:
	var direction = Vector2.ZERO
	if player_chase:
		print("chase")
		direction = (player.position - position).normalized()
		
	_velocity(_delta, direction, dash_acceleration_multiplyer, dash_max_speed_multiplyer)
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Player detected")
	player = body
	player_chase = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	player = body
	player_chase = false



signal enemy_died
func _on_health_component_died() -> void:
	emit_signal("enemy_died")
	queue_free()


func _on_health_component_health_changed(current_health: int) -> void:
	print("Health changed: ", current_health)
