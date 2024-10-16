extends Area2D

# Reference to the HealtComponent component
@export var health_component: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_collision_layer(1)
	set_collision_mask(3)
	print(get_collision_layer())
	print(get_collision_mask())

# Initialize the hitbox with the Health component
func initialize(health: Node) -> void:
	health_component = health

# Called when another body enters the hitbox
func _on_body_entered(body: Node2D) -> void:
	print("body entered")
	if body.has_method("get_damage"):
		var damage = body.get_damage()
		if health_component:
			health_component.take_damage(damage)
	else:
		print("Body does not have get_damage method")

func _on_body_exited(body: Node2D) -> void:
	print("body exited")
	if body.has_method("get_damage"):
		var damage = body.get_damage()
		if health_component:
			health_component.take_damage(damage)
	else:
		print("Body does not have get_damage method")
		
func _process(delta: float) -> void:
	print("bullet")
	print(get_collision_layer())
	print(get_collision_mask())
