extends Node2D
class_name EnemyGun

const BulletSpeed = 500
const Distance = 50  # Distance from the gun where the bullet spawns
const reloadTime = 0.3
var isShooting = false

@export var bulletScene = preload("res://wepons/projectils/simple_damage_projectil/enemy_bullet.tscn")
var target_position: Vector2 = Vector2.ZERO  # The position the gun aims at

func aim_at(target: Vector2) -> void:
	# Set the target position and rotate to aim at it
	target_position = target
	look_at(target_position)

func shoot():
	if !isShooting:
		isShooting = true
		# Instance the bullet
		var bullet = bulletScene.instantiate()
		# Set the position of the bullet to the player's position
		bullet.position = get_parent().position + Vector2(cos(rotation)*Distance, sin(rotation)*Distance)
		
		bullet.scale = Vector2(0.5, 0.5)  # Adjust scale values as needed (e.g., 0.5 for half size)
		
		bullet.get_node("Sprite2D").modulate = Color(1, 0, 0)  # Set to red

		
		# Calculate the velocity based on the shooting direction and bullet speed
		bullet.velocity = Vector2(cos(rotation)*BulletSpeed, sin(rotation)*BulletSpeed) + get_parent().velocity/2
		
		# Add the bulet to the scene (usually as a child of the current scene)
		get_parent().get_parent().add_child(bullet)

		
		await get_tree().create_timer(reloadTime).timeout
		isShooting = false
