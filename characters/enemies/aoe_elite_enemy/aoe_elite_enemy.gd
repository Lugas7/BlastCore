extends CharacterBody2D
class_name aoe_elite_enemy

# Dash-related properties
@export var dash_speed: float = 800
@export var dash_duration: float = 0.4
@export var dash_cooldown: float = 1.5
@export var charge_time: float = 0.5
@export var melee_range: float = 50.0
@export var melee_damage: int = 15

# Shooting-related properties
@export var shoot_interval: float = 1.2
@export var detection_range: float = 800.0
@export var Distance: float = 50.0 

# General properties
@export var wander_speed: float = 100
@export var wander_time: float = 2.0

var player = null
var is_charging = false
var is_dashing = false
var cooldown_time_left = 0
var charge_time_left = 0
var dash_time_left = 0
var wander_time_left = 0
var wander_direction = Vector2.ZERO
var can_shoot = true

@onready var hc = get_node("HealthComponent")
@onready var health_bar = $HealthBar
@onready var sprite = $Sprite2D
@onready var damage_area = $DamageArea

# Gun nodes
@onready var gun_nodes = [
	$EnemyGun1, $EnemyGun2, $EnemyGun3,
	$EnemyGun4, $EnemyGun5, $EnemyGun6,
	$EnemyGun7, $EnemyGun8, $EnemyGun9
]

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	damage_area.monitoring = false
	sprite.modulate = Color(1, 1, 1)
	set_new_wander_direction()

func _physics_process(delta: float) -> void:
	if player:
		handle_player_behavior(delta)
	else:
		handle_wandering(delta)

	move_and_slide()

func handle_player_behavior(delta: float) -> void:
	var direction = (player.position - position).normalized()

	if is_charging:
		charge_time_left -= delta
		if charge_time_left <= 0:
			start_dash(direction)

	elif is_dashing:
		velocity = direction * dash_speed
		dash_time_left -= delta
		if dash_time_left <= 0:
			end_dash()

	elif cooldown_time_left > 0:
		cooldown_time_left -= delta

	elif player:
		start_charge()

	# Shooting behavior
	if is_in_range() and can_shoot:
		shoot_from_all_guns()

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
		sprite.modulate = Color(1, 0, 0)  

func start_dash(direction: Vector2) -> void:
	is_charging = false
	is_dashing = true
	dash_time_left = dash_duration
	velocity = direction * dash_speed
	sprite.modulate = Color(1, 1, 1)  
	damage_area.monitoring = true
	sprite.flip_h = direction.x < 0

func end_dash() -> void:
	is_dashing = false
	cooldown_time_left = dash_cooldown
	damage_area.monitoring = false
	velocity = Vector2.ZERO

func is_in_range() -> bool:
	return position.distance_to(player.position) <= detection_range

func shoot_from_all_guns() -> void:
	for gun in gun_nodes:
		if gun:
			# Instance the bullet
			var bullet = gun.bulletScene.instantiate()
			
			# Set the bullet's position 
			bullet.position = gun.global_position + Vector2(cos(gun.global_rotation) * Distance, sin(gun.global_rotation) * Distance)
			
			# Set slower velocity
			bullet.velocity = Vector2(cos(gun.global_rotation), sin(gun.global_rotation)) * 300  # Adjusted slower speed
			
			# bullets a bit lbigger 
			bullet.scale = Vector2(0.7, 0.7)
			bullet.get_node("Sprite2D").modulate = Color(1, 0, 0)
			
			# Add the bullet to the scene
			get_tree().root.add_child(bullet) 
			
	can_shoot = false
	get_tree().create_timer(shoot_interval).timeout.connect(func():
		can_shoot = true)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == player:
		player = null

func _on_health_component_died() -> void:
	queue_free()

func _on_health_component_health_changed(current_health: int) -> void:
	health_bar.setPercent(100 * current_health/ hc.max_health)
