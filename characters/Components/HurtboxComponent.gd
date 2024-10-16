extends Area2D

# How much damage the hurtbox shall inflict
@export var damage: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Initialize the hitbox with the Health component
func initialize() -> void:
	pass

#var health_component: health_component = preload("res://hurtbox_component")

# Called when another body enters the hitbox
func _on_area_entered(body: Area2D) -> void:
	#print(body.get_method_list())
	print("body entered: " + str(body))
	if body.has_method("take_damage"):
		body.take_damage(damage)
	else:
		print("Area does not have take_damage method")


#func _on_body_exited(body: Node2D) -> void:
	#print("body exited")
	#if body.has_method("get_damage"):
		#var damage = body.get_damage()
		#if health_component:
			#health_component.take_damage(damage)
	#else:
		#print("Body does not have get_damage method")
		
func _process(delta: float) -> void:
	var list = get_overlapping_areas()
	if len(list) < 0:
		print(list)
	#print("l: " + str(get_collision_layer()))
	#print("m: " + str(get_collision_mask()))
	#print("bullet")
	#print(get_collision_layer())
	#print(get_collision_mask())
