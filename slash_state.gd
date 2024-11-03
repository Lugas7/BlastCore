extends State
class_name SlashState

@export var slashArea: CollisionShape2D
@export var swordSprite: Sprite2D
const slashTime = 0.1
var slashTimeLeft
const slashDistance = PI/2

@onready var sword = get_parent().get_parent()



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

func exit() -> void:
	slashArea.disabled = true
	swordSprite.visible = false

func update(delta: float) -> void:
	sword.rotate(delta/slashTime*slashDistance)
	slashTimeLeft -= delta
	if slashTimeLeft <= 0:
		emit_signal("transition", "NoneState", self)
		return
