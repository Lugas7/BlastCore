extends CharacterBody2D

@export var dash_speed: float = 800
@export var dash_duration: float = 0.2
@export var dash_cooldown: float = 1.0
@export var melee_range: float = 50.0
@export var melee_damage: int = 10

var player = null
var is_dashing = false
var dash_time_left = 0
var cooldown_time_left = 0

@onready var hc = get_node("health_component")
@onready var sprite = $Sprite2D  # Reference to the Sprite2D node

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO

	# Chase player if within detection range
	if player:
		direction = (player.position - position).normalized()
		if is_in_melee_range():
			attack_player()

	if is_dashing:
		velocity = direction * dash_speed
		dash_time_left -= delta
		if dash_time_left <= 0:
			is_dashing = false
			cooldown_time_left = dash_cooldown
	else:
		velocity = Vector2.ZERO
		if cooldown_time_left > 0:
			cooldown_time_left -= delta
		elif player:
			start_dash(direction)

	move_and_slide()

func start_dash(direction: Vector2) -> void:
	if cooldown_time_left <= 0:
		is_dashing = true
		dash_time_left = dash_duration
		velocity = direction * dash_speed
		print("Enemy is dashing!")  # Debug log
		# Optionally flip sprite based on direction
		sprite.flip_h = direction.x < 0

func is_in_melee_range() -> bool:
	return player and position.distance_to(player.position) <= melee_range

func attack_player() -> void:
	if player and player.has_method("take_damage"):
		player.take_damage(melee_damage)
		print("Player took damage!")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):  # Ensure the body is the player
		player = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == player:
		player = null

func _on_health_component_died() -> void:
	print("Enemy died")
	queue_free()

func _on_health_component_health_changed(current_health: int) -> void:
	print("Enemy health changed: ", current_health)
