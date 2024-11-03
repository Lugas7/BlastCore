extends CharacterBody2D
class_name Player


var xinput = 0
var yinput = 0
var xdir = 0
var ydir = 0
func _physics_process(_delta: float) -> void:
	# print("layer " + str(get_collision_layer()))
	# print("mask "+ str(get_collision_mask()))
		#print("Player Area2D, layer: " + str(get_node("Area2D").get_collision_layer()) + ", layer value: " + str(get_node("Area2D").get_collision_mask()))
	#if Input.is_action_pressed("shoot"):
	#	gun.shoot()
	move_and_slide()

func setSpeed(speed):
	updateDirection()
	velocity.x = speed * xdir
	velocity.y = speed * ydir

func updateDirection():
	xinput = Input.get_axis("ui_left", "ui_right")
	yinput = Input.get_axis("ui_up", "ui_down")
	
	if xinput != 0 and yinput != 0:
		var dir = atan2(yinput, xinput)
		xdir = cos(dir)
		ydir = sin(dir)	
	else:
		xdir = xinput
		ydir = yinput
		
	

#var bulletScene = preload("res://bullet.tscn")
#
#func shoot():
	#print("shooting")
	## Instance the bullet
	#var bullet = bulletScene.instantiate()
	##add_child(bullet)
#
	## Set the position of the bullet to the player's position
	#bullet.position = position + Vector2()
	#
	## Calculate the velocity based on the shooting direction and bullet speed
	#bullet.linear_velocity = Vector2(100, 0)
	#
	## Add the bulet to the scene (usually as a child of the current scene)
	#get_parent().add_child(bullet)
