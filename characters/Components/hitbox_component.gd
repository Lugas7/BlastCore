extends Area2D

# Reference to the Health component
@export var health_component: Health

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    connect("body_entered", self, "_on_body_entered")

# Initialize the hitbox with the Health component
func initialize(health: Health) -> void:
    health_component = health

# Called when another body enters the hitbox
func _on_body_entered(body: Node) -> void:
    if body.has_method("get_damage"):
        var damage = body.get_damage()
        if health_component:
            health_component.take_damage(damage)