extends Area2D

# Reference to the HealtComponent component
@export var health_component: HealthComponent
@export var damage_multiplier:= 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_collision_layer(1)
	set_collision_mask(3)
	print(get_collision_layer())
	print(get_collision_mask())
	print(str(health_component))


func _on_area_entered(area: Area2D) -> void:
	if area.has_method("get_damage"):
		var damage = area.get_damage()
		damage = int(damage * damage_multiplier)
		if health_component:
			print("here")
			health_component.take_damage(damage)
	else:
		print("hit area does not have get_damage method")


func _on_area_exit(area: Area2D) -> void:
	pass # Replace with function body.
