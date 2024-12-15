extends CharacterBody2D

# Configuration variables
@export var shoot_interval: float = 0.1  # Time between each shot
@export var detection_range: float = 500.0  # Range at which the enemy detects the player
@export var max_shots: int = 10  # Maximum shots before pausing for reload
@export var reload_time: float = 2.0  # Time required to reload
@export var move_speed: float = 200.0  # Movement speed of the enemy
@export var stop_distance: float = 0.1  # Minimum distance to the player before stopping
@export var gun_offset: Vector2 = Vector2(0, 0)  # Offset for the gun's position
@export var fire_scene: PackedScene = preload("res://wepons/projectils/fire/enemy_fire.tscn")  # Scene for the fire projectile

# State variables
var player = null  # Reference to the player
var can_shoot = true  # Tracks if the enemy can shoot
var shots_fired: int = 0  # Counter for the number of shots fired
var is_reloading: bool = false  # Tracks if the enemy is reloading
var reload_timer: Timer = null  # Timer for reload logic

# Health and UI properties
@onready var hc = $HealthComponent  # Reference to the health component
@onready var health_bar = $HealthBar  # Reference to the health bar
@export var health_bar_offset: Vector2 = Vector2(-25, -40)  # Offset for the health bar position

func _ready() -> void:
	# Initialize the health component and health bar
	if hc:
		hc.max_health = 200  # Set the maximum health
		hc.current_health = hc.max_health  # Start with full health
		hc.health_changed.connect(_on_health_changed)  # Connect to health change signal
		hc.died.connect(_on_health_died)  # Connect to death signal
	else:
		print("HealthComponent not found!")

	if health_bar:
		health_bar.set_value(100)  # Set health bar to full at start
		health_bar.visible = true
		health_bar.set_as_top_level(true)  # Detach health bar from inherited transforms
		health_bar.position = position + health_bar_offset

	# Create and set up the reload timer
	reload_timer = Timer.new()
	reload_timer.wait_time = reload_time
	reload_timer.one_shot = true
	reload_timer.timeout.connect(_on_reload_timer_timeout)
	add_child(reload_timer)

func _physics_process(delta: float) -> void:
	# Handle movement and shooting logic
	if player:
		move_towards_player(delta)  # Move towards the player
		if is_in_range():
			aim_at_player()  # Face the player
			if can_shoot and not is_reloading:
				shoot()

	# Update the position of the health bar
	if health_bar:
		health_bar.position = position + health_bar_offset

func move_towards_player(delta: float) -> void:
	# Move the enemy towards the player if within detection range
	if player:
		var distance_to_player = position.distance_to(player.position)
		if distance_to_player <= detection_range:
			if distance_to_player > stop_distance:  # Move closer if not too near
				var direction = (player.position - position).normalized()
				velocity = direction * move_speed
			else:
				velocity = Vector2.ZERO  # Stop if too close
		else:
			velocity = Vector2.ZERO  # Stop if outside detection range
	move_and_slide()

func is_in_range() -> bool:
	# Check if the player is within detection range
	if player:
		var distance_to_player = position.distance_to(player.position)
		return distance_to_player <= detection_range
	return false

func aim_at_player() -> void:
	# Rotate the enemy to face the player
	if player:
		look_at(player.position)

func shoot() -> void:
	# Instantiate and fire a projectile if the enemy can shoot
	if fire_scene and can_shoot and is_in_range():
		var fire = fire_scene.instantiate()
		
		# Set projectile position and direction
		fire.position = global_position + gun_offset.rotated(rotation)
		fire.rotation = rotation
		fire.flame_velocity = Vector2(cos(rotation), sin(rotation))  # Assign projectile velocity
		
		# Add the projectile to the scene
		get_tree().current_scene.add_child(fire)

		# Update shooting state
		shots_fired += 1
		can_shoot = false
		get_tree().create_timer(shoot_interval).timeout.connect(func():
			can_shoot = true)

		# Start reload if max shots are reached
		if shots_fired >= max_shots:
			start_reload()

func start_reload() -> void:
	# Start the reload process
	is_reloading = true
	reload_timer.start()
	print("Reloading...")

func _on_reload_timer_timeout() -> void:
	# Reset shooting state after reload
	is_reloading = false
	shots_fired = 0
	print("Reload complete. Ready to fire again.")

func _on_health_changed(current_health: int) -> void:
	# Update the health bar when health changes
	if health_bar and hc:
		health_bar.set_value(100 * current_health / hc.max_health)
		print("Health updated: ", current_health)

func _on_health_died() -> void:
	# Handle enemy death
	print("Enemy died")
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	# Detect when the player enters the enemy's range
	if body.is_in_group("Player"):
		player = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	# Detect when the player leaves the enemy's range
	if body == player:
		player = null
