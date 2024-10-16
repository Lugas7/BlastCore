extends CharacterBody2D

var speed = 150
var player = null
var player_chase = false
var player_left = true
var health: Health
var hitbox: HitboxComponent

func _ready() -> void:
    # Initialize Health component
    health = Health.new()
    health._init(100)  # Set max health to 100
    add_child(health)
    health.connect("health_changed", self, "_on_health_changed")
    health.connect("died", self, "_on_died")

    # Initialize Hitbox component
    hitbox = HitboxComponent.new()
    add_child(hitbox)
    hitbox.initialize(health)

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

func _on_health_changed(current_health: int) -> void:
    print("Health changed: ", current_health)

func _on_died() -> void:
    print("Enemy died")
    queue_free()

# Example method to enable invincibility
func enable_invincibility():
    health.set_invincible(true)

# Example method to disable invincibility
func disable_invincibility():
    health.set_invincible(false)