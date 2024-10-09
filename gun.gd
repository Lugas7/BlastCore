extends RigidBody2D

const TotalForce = -500
const BulletSpeed = 300
const Distance = 150

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	pass

var bulletScene = preload("res://bullet.tscn")

func shoot():
	# Instance the bullet
	var bullet = bulletScene.instantiate()
	# Set the position of the bullet to the player's position
	bullet.position = position + Vector2(cos(rotation)*Distance, sin(rotation)*Distance)
	
	# Calculate the velocity based on the shooting direction and bullet speed
	bullet.linear_velocity = Vector2(cos(rotation)*BulletSpeed, sin(rotation)*BulletSpeed)
	
	# Add the bulet to the scene (usually as a child of the current scene)
	get_parent().add_child(bullet)
