extends CharacterBody2D

@export var shoot_interval: float = 1.0  # Time between shots
@export var detection_range: float = 500.0  # Shooting range
@export var bullet_speed: float = 500.0  # Speed of bullets
@export var gun_offset: Vector2 = Vector2(0, 0)  # Offset for gun position
@export var chase_speed: float = 50.0  # Slow movement speed for chasing

var player = null
var can_shoot = true  # Shooting cooldown control

@onready var hc = get_node("health_component")  # Health Component
@onready var sprite = $Sprite2D  # Reference to the Sprite2D node
@onready var gun = $EnemyGun  # Reference to the Gun node

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO

	# Check if the player is in range and aim/shoot
	if player:
		if is_in_range():
			aim_at_player()
			if can_shoot:
				shoot()

		# Move slowly toward the player
		direction = (player.position - position).normalized()

	# Apply slow movement
	velocity = direction * chase_speed
	move_and_slide()

func is_in_range() -> bool:
	return position.distance_to(player.position) <= detection_range

func aim_at_player() -> void:
	# Rotate the gun to aim at the player
	if player:
		gun.look_at(player.position)

func shoot() -> void:
	if gun and !gun.isShooting:
		gun.shoot()  # Call the Gun's shoot method
		can_shoot = false
		# Cooldown before the next shot
		get_tree().create_timer(shoot_interval).timeout.connect(func():
			can_shoot = true)

func _on_area_2d_body_entered(body: Node2D) -> void:
	# Detect if the player enters the shooting range
	if body.is_in_group("Player"):
		player = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	# Stop targeting the player when they leave the range
	if body == player:
		player = null

func _on_health_component_died() -> void:
	print("Enemy died")
	queue_free()

func _on_health_component_health_changed(current_health: int) -> void:
	print("Enemy health changed: ", current_health)
