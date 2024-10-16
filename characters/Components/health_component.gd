extends Node

# Signal to notify when health changes or entity dies
signal health_changed(current_health)
signal died()

# Exported variables for health
@export var max_health: int = 100
@export var invincible: bool = false

# Current health variable
var current_health: int

# Initialize health values
func _init(max_health: int):
    self.max_health = max_health
    self.current_health = max_health

# Method to take damage
func take_damage(amount: int) -> void:
    if invincible:
        return
    current_health -= amount
    if current_health <= 0:
        current_health = 0
        emit_signal("died")
    emit_signal("health_changed", current_health)

# Method to heal
func heal(amount: int) -> void:
    current_health += amount
    if current_health > max_health:
        current_health = max_health
    emit_signal("health_changed", current_health)

# Method to check if the entity is dead
func is_dead() -> bool:
    return current_health <= 0

# Methods to enable and disable invincibility
func set_invincible(value: bool) -> void:
    invincible = value