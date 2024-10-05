extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(_delta: float) -> void:
	# Add the gravity.
	#if not is_on_floor():
	#	velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var xinput := Input.get_axis("ui_left", "ui_right")
	var yinput := Input.get_axis("ui_up", "ui_down")

	var dir = atan2(yinput, xinput)
	var xdir = cos(dir)
	var ydir = sin(dir)

	if xinput:
		velocity.x = xdir * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if yinput:
		velocity.y = ydir * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)	
	move_and_slide()
