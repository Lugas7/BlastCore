extends State
class_name SlashState

@export var slashArea: CollisionShape2D
@export var slashTime = 0.2
@export var sword: Sword
var slashTimeLeft
const slashDistance = PI/2
var slashSpeed = 0

# the sword abjects taht will slash
#@onready var sword: Sword = get_parent().get_parent()
@onready var swordSprite = sword.swordSprite




func enter(last_state: State = null) -> void:
	slashTimeLeft = slashTime
	# gets player nodes position and calculates angle to the mouse  and sets the start value to be the 
	#sword.rotation = PI/2
	#print(sword.get_parent().position.angle_to(sword.get_parent().get_mouse_position()))
	#sword.rotation = sword.get_parent().position.angle_to(sword.get_parent().get_mouse_position())
	sword.look_at(sword.get_global_mouse_position())
	sword.rotate(-slashDistance/2)
	slashArea.disabled = false
	swordSprite.visible = true
	slashSpeed = slashDistance/slashTime

func exit() -> void:
	slashArea.disabled = true
	swordSprite.visible = false

func update(delta: float) -> void:
	# change the sword rotation to slash
	sword.rotate(slashSpeed * delta)
	slashTimeLeft -= delta
	if slashTimeLeft <= 0:
		emit_signal("transition", "NoneState", self)
		return
