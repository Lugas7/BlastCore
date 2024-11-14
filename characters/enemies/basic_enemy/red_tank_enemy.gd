extends MovementCharacterBody2D

var player = null
var player_chase = false
var player_left = true

signal died

func _ready() -> void:
	add_to_group("Enemy")
	pass

func _physics_process(_delta: float) -> void:
	var direction = Vector2.ZERO
	if player_chase:
		print("chase")
		direction = (player.position - position).normalized()
		
		player_left = direction.x < 0
		# position += direction * speed * _delta
		$AnimatedSprite2D.play("left movement")
		$AnimatedSprite2D.flip_h = !player_left
	_velocity(_delta, direction)
	move_and_slide()

@onready
var hc = get_node("health_component")

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Player detected")
	player = body
	player_chase = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	player = body
	player_chase = false




func _on_health_component_died() -> void:
	print("Enemy died")
	emit_signal("died")
	queue_free()


func _on_health_component_health_changed(current_health: int) -> void:
	print("Health changed: ", current_health)
	
	
