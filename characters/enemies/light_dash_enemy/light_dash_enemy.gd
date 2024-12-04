extends CharacterBody2D
class_name light_dash_enemy

@export var dash_speed: float = 800
@export var dash_duration: float = 0.2
@export var dash_cooldown: float = 1.0
@export var charge_time: float = 0.5
@export var melee_range: float = 50.0
@export var melee_damage: int = 10
@export var wander_speed: float = 100  
@export var wander_time: float = 2.0  

var player = null
var is_charging = false
var is_dashing = false
var is_wandering = true  
var charge_time_left = 0
var dash_time_left = 0
var cooldown_time_left = 0
var wander_time_left = 0
var wander_direction = Vector2.ZERO

@onready var hc = get_node("HealthComponent")
@onready var health_bar = $HealthBar
@onready var sprite = $Sprite2D
@onready var damage_area = $DamageArea

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	damage_area.monitoring = false
	sprite.modulate = Color(1, 1, 1)  # Reset color to normal
	set_new_wander_direction()

func _physics_process(delta: float) -> void:
	if player:
		handle_player_behavior(delta)
	else:
		handle_wandering(delta)

	# Move using the built-in velocity property
	move_and_slide()

func handle_player_behavior(delta: float) -> void:
	var direction = (player.position - position).normalized()

	# Handle charging up for a dash
	if is_charging:
		charge_time_left -= delta
		if charge_time_left <= 0:
			start_dash(direction)

	# Handle dashing
	elif is_dashing:
		velocity = direction * dash_speed
		dash_time_left -= delta
		if dash_time_left <= 0:
			end_dash()

	# Handle cooldown after a dash
	elif cooldown_time_left > 0:
		cooldown_time_left -= delta

	# Start charging if player is available and no cooldown
	elif player:
		start_charge()

func handle_wandering(delta: float) -> void:
	wander_time_left -= delta
	if wander_time_left <= 0:
		set_new_wander_direction()

	velocity = wander_direction * wander_speed

func set_new_wander_direction() -> void:
	wander_time_left = wander_time
	var angle = rng.randf_range(0, PI * 2)
	wander_direction = Vector2(cos(angle), sin(angle))

func start_charge() -> void:
	if cooldown_time_left <= 0 and not is_dashing and not is_charging:
		is_charging = true
		charge_time_left = charge_time
		sprite.modulate = Color(1, 0, 0)  # Turn red during windup

func start_dash(direction: Vector2) -> void:
	is_charging = false
	is_dashing = true
	dash_time_left = dash_duration
	velocity = direction * dash_speed
	sprite.modulate = Color(1, 1, 1)  # Reset color to normal
	damage_area.monitoring = true
	sprite.flip_h = direction.x < 0

func end_dash() -> void:
	is_dashing = false
	cooldown_time_left = dash_cooldown
	damage_area.monitoring = false
	velocity = Vector2.ZERO

func is_in_melee_range() -> bool:
	return player and position.distance_to(player.position) <= melee_range

func attack_player() -> void:
	if player and player.has_method("take_damage"):
		player.take_damage(melee_damage)
		print("Player took damage!")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body
		is_wandering = false  # Stop wandering when the player is detected

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
		is_wandering = true  # Resume wandering when the player is lost

func _on_health_component_died() -> void:
	print("Enemy died")
	queue_free()

func _on_health_component_health_changed(current_health: int) -> void:
	health_bar.set_value(100 * current_health / hc.max_health)
	print("Enemy health changed: ", current_health)
