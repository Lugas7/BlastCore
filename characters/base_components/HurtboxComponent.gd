extends Area2D

# Reference to the HealtComponent component
@export var health: HealthComponent
@export var damage_multiplier:= 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_collision_layer(1)
	set_collision_mask(3)
	print(get_collision_layer())
	print(get_collision_mask())
	print(str(health))


func _process(delta: float) -> void:
	# print("bullet")
	# print(get_collision_layer())
	# print(get_collision_mask())
	pass


func _on_area_entered(area: Area2D) -> void:
	print("hit area entered, function damage ->", str(area.has_method("get_damage")))
	if area.has_method("get_damage"):
		var damage = area.get_damage()
		damage = int(damage * damage_multiplier)
		print("hit area entered damage = "+ str(damage))
		print(str(health))
		if health:
			print("here")
			health.take_damage(damage)
	else:
		print("hit area does not have get_damage method")


func _on_area_exited(area: Area2D) -> void:
	if area.has_method("get_damage"):
		var damage = area.get_damage()
		if health:
			health.take_damage(damage)
	else:
		print("hit area does not have get_damage method")
