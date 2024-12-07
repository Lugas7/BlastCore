extends Area2D

# Reference to the HealtComponent component
@export var health_component: HealthComponent
@export var damage_multiplier:= 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _on_area_entered(area: Area2D) -> void:
	print("area entered in hurtboxcomponent")
	
	if area.has_method("get_damage"):
		var damage = area.get_damage()
		damage = int(damage * damage_multiplier)
		if health_component:
			print("here")
			health_component.take_damage(damage)
