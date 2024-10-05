extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const dashTime = 0.3
const DASHSPEED = 900

var isDashing = false
var xinput = 0
var yinput = 0
var xdir = 0
var ydir = 0
func _physics_process(_delta: float) -> void:
	updateMovement()
	if Input.is_action_pressed("ui_dash"):
		beginDash()
	if !isDashing:
		velocity.x = SPEED * xdir
		velocity.y = SPEED * ydir
	move_and_slide()

func updateMovement():
	if isDashing == false:
		xinput = Input.get_axis("ui_left", "ui_right")
		yinput = Input.get_axis("ui_up", "ui_down")
		
		if xinput != 0 and yinput != 0:
			var dir = atan2(yinput, xinput)
			xdir = cos(dir)
			ydir = sin(dir)	
		else:
			xdir = xinput
			ydir = yinput
		

func beginDash():
	isDashing = true
	velocity.x = DASHSPEED * xdir
	velocity.y = DASHSPEED * ydir
	await get_tree().create_timer(dashTime).timeout
	isDashing = false
