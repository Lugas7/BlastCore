extends State
class_name SpinState

@export var slashArea: CollisionShape2D
@export var slashTime = 0.2
@export var sword: Sword
var slashTimeLeft
var slashSpeed = 5

# the sword abjects taht will slash
#@onready var sword: Sword = get_parent().get_parent()
@onready var swordSprite = sword.swordSprite




func enter(last_state: State = null) -> void:
	print(swordSprite)
	slashArea.disabled = false
	swordSprite.visible = true

func exit() -> void:
	slashArea.disabled = true
	swordSprite.visible = false

func update(delta: float) -> void:
	# change the sword rotation to slash
	sword.rotate(slashSpeed * delta)
