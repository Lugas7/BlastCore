extends Node2D
class_name Gun

const TotalForce = -500
const Distance = 150


const BulletSpeed_d = 750
const BulletSpeed_u = 1500


const BulletScale_d = 1.0
const BulletScale_u = 1.8

var BulletSpeed = BulletSpeed_d
var BulletScale = BulletScale_d
var BulletBounce = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	look_at(get_global_mouse_position())

var bulletScene = preload("res://wepons/projectils/simple_damage_projectil/bullet.tscn")

# shoots a bullet at angle of gun
func shoot():
	# Instance the bullet
	var bullet = bulletScene.instantiate()
	# Set the position of the bullet to the player's position
	bullet.position = get_parent().position + Vector2(cos(rotation)*Distance, sin(rotation)*Distance)
	
	# Calculate the velocity based on the shooting direction and bullet speed
	bullet.velocity = Vector2(cos(rotation)*BulletSpeed, sin(rotation)*BulletSpeed)
	bullet.scale = Vector2(BulletScale, BulletScale)
	bullet.bounce = BulletBounce

	# Add the bulet to the scene (usually as a child of the current scene)
	get_parent().get_parent().add_child(bullet)
	
	return bullet

# shoots bullet but sets the layer to 7 which is where the players hurtbox is
func shootPlayer():
	var bullet = await shoot()
	bullet.get_node("SimpleDamageArea").collision_layer = pow(2, 6) # setting layer 7
	#bullet.collision_mask = pow(2, 0)
	return bullet
