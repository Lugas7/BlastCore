extends CharacterBody2D

@export var shoot_interval: float = 1.0  # Time between shots
@export var detection_range: float = 800.0  # Shooting range
@export var bullet_speed: float = 500.0  # Speed of bullets
@export var gun_offset: Vector2 = Vector2(0, 0)  # Offset for gun position
@export var escape_speed: float = 50.0  # Slow movement speed for escaping

var player = null
var can_shoot = true  # Shooting cooldown control

@onready var hc = $HealthComponent  # Reference to the HealthComponent node
@onready var health_bar = $HealthBar  # Reference to the Health Bar
@onready var sprite = $Sprite2D  # Reference to the Sprite2D node
@onready var gun = $EnemyGun  # Reference to the Gun node

func _ready() -> void:
	add_to_group("Enemy")
	# Connect signals from HealthComponent
	hc.health_changed.connect(_on_health_component_health_changed)
	hc.died.connect(_on_health_component_died)

func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO

	if player:
		if is_in_range():
			aim_at_player()
			if can_shoot:
				shoot()

		# Move slowly away from the player
		direction = (position - player.position).normalized()

	velocity = direction * escape_speed
	move_and_slide()

func is_in_range() -> bool:
	return position.distance_to(player.position) <= detection_range

func aim_at_player() -> void:
	if player:
		gun.look_at(player.position)

func shoot() -> void:
	if gun and !gun.isShooting:
		gun.shoot()
		can_shoot = false
		get_tree().create_timer(shoot_interval).timeout.connect(func():
			can_shoot = true)

func _on_health_component_died() -> void:
	print("Enemy died")
	queue_free()

func _on_health_component_health_changed(current_health: int) -> void:
	health_bar.setPercent(100 * current_health / hc.max_health)
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
