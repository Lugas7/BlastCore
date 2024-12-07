extends Area2D

signal damage_dealt()

@export var damage: int = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	print("collision layer then mask for simple damage area:")
	print(collision_layer)
	print(collision_mask)
	print()
	# set_collision_layer(3)
	# set_collision_mask(1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func get_damage() -> int:
	emit_signal("damage_dealt")
	return damage
