extends Area2D

var dir

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(on_Door_body_entered)
	
	# Set the direction of the door
	match name:
		"DoorRight":
			dir = 0  # Right
		"DoorUp":
			dir = 1  # Up
		"DoorLeft":
			dir = 2  # Left
		"DoorDown":
			dir = 3  # Down
		_:
			dir = -1  # Invalid direction


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func on_Door_body_entered(body) -> void:
	if body.is_in_group("Player"):
		var parentNode = get_parent().get_parent()
		parentNode.nextRoom(dir)
