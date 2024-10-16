extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_collision_layer(3)
	set_collision_mask(1)
	print("bullet")
	print(get_collision_layer())
	print(get_collision_mask())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

