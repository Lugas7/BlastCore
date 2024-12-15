extends CharacterBody2D

# Configurable properties for the flame
@export var flame_lifetime: float = 2.0  # Lifetime of the flame before it disappears
@export var flame_damage: int = 5        # Damage dealt by the flame
@export var flame_scale: Vector2 = Vector2(0.05, 0.05)  # Scale of the flame sprite
@export var fire_speed: float = 400.0    # Speed at which the flame moves

# Velocity vector for the flame's movement
var flame_velocity: Vector2 = Vector2.ZERO

# Collision properties
var bounce = false  # Determines if the flame should bounce upon collision
var bouncesLeft = 2  # Number of bounces allowed before the flame disappears

func _ready() -> void:
	# Initialize the flame's texture and scale
	if $Sprite2D:
		$Sprite2D.texture = preload("res://assets/fire/fire.png")  # Set the flame texture
		$Sprite2D.scale = flame_scale  # Adjust the size of the flame
	
	# Set up a timer to remove the flame after its lifetime expires
	var lifetime_timer = Timer.new()
	lifetime_timer.wait_time = flame_lifetime
	lifetime_timer.one_shot = true
	lifetime_timer.timeout.connect(queue_free)  # Remove the flame when the timer expires
	add_child(lifetime_timer)
	lifetime_timer.start()

func _physics_process(delta: float) -> void:
	# Move the flame forward using its velocity and speed
	velocity = flame_velocity.normalized() * fire_speed
	var collision = move_and_collide(velocity * delta)
	
	# Handle collisions if any occur
	if collision:
		handle_collision(collision)

func handle_collision(collision: KinematicCollision2D) -> void:
	# Get the object that was hit
	var collider = collision.get_collider()
	
	# Check if the collider can take damage
	if collider and collider.has_method("take_damage"):
		collider.take_damage(flame_damage)  # Apply damage to the collider
		queue_free()  # Remove the flame after dealing damage
	elif bounce and bouncesLeft > 0:
		# Handle bouncing logic if enabled and bounces remain
		var normal = collision.get_normal()  # Get the surface normal of the collision
		flame_velocity = flame_velocity.bounce(normal)  # Reflect the flame's direction
		bouncesLeft -= 1
	else:
		# Remove the flame if it can't bounce or has no bounces left
		queue_free()

func get_damage() -> int:
	# Returns the damage dealt by the flame
	return flame_damage
