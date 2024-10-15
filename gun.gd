extends RigidBody2D

const TotalForce = -500
const BulletSpeed = 500
const Distance = 150
const reloadTime = 0.3
var isShooting = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	pass

var bulletScene = preload("res://bullet.tscn")

func shoot():
	if !isShooting:
		isShooting = true
		# Instance the bullet
		var bullet = bulletScene.instantiate()
		# Set the position of the bullet to the player's position
		bullet.position = get_parent().position + Vector2(cos(rotation)*Distance, sin(rotation)*Distance)
		
		# Calculate the velocity based on the shooting direction and bullet speed
		bullet.velocity = Vector2(cos(rotation)*BulletSpeed, sin(rotation)*BulletSpeed) + get_parent().velocity/2
		#bullet.move_and_slide()
		
		# Add the bulet to the scene (usually as a child of the current scene)
		get_parent().get_parent().add_child(bullet)
		
		await get_tree().create_timer(reloadTime).timeout
		isShooting = false
