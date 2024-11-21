extends Node2D
class_name Gun

const TotalForce = -500
const Distance = 150
var isShooting = false


const BulletSpeed = 750
const BulletSpeedUpgraded = 1250

const ReloadTime = 0.5
const ReloadTimeUpgraded = 0.3

const upgradedBulletScale = 1.8
const BulletScaleUpgraded = Vector2(upgradedBulletScale, upgradedBulletScale)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	look_at(get_global_mouse_position())

var bulletScene = preload("res://wepons/projectils/simple_damage_projectil/bullet.tscn")

func shoot():
	if !isShooting:
		isShooting = true
		# Instance the bullet
		var bullet = bulletScene.instantiate()
		# Set the position of the bullet to the player's position
		bullet.position = get_parent().position + Vector2(cos(rotation)*Distance, sin(rotation)*Distance)
		
		# Get upgrades
		var upgrades = get_parent().upgrades
		var fastBullets = upgrades["fast_bullets"]
		var fastShot = upgrades["fast_shot"]
		var bigBullets = upgrades["big_bullets"]
		var bulletBounce = upgrades["bullet_bounce"]
		
		var bulletSpeed = BulletSpeedUpgraded if fastBullets else BulletSpeed
		var reloadTime = ReloadTimeUpgraded if fastShot else ReloadTime
		
		# Calculate the velocity based on the shooting direction and bullet speed
		bullet.velocity = Vector2(cos(rotation)*bulletSpeed, sin(rotation)*bulletSpeed)
		bullet.scale = BulletScaleUpgraded if bigBullets else Vector2(1.0, 1.0)
		bullet.bounce = bulletBounce
		
		# Add the bulet to the scene (usually as a child of the current scene)
		get_parent().get_parent().add_child(bullet)

		await get_tree().create_timer(reloadTime).timeout
		isShooting = false
