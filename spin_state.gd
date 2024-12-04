extends State
class_name SpinState

#export var slashArea: CollisionShape2D
@export var slashTime = 0.2
@export var sword: Sword
var slashTimeLeft
var slashSpeed = 2

# the sword abjects taht will slash
#@onready var sword: Sword = get_parent().get_parent()
@onready var swordSprite = sword.sprite
@onready var slashArea = sword.swordCollisionShape



func enter(last_state: State = null) -> void:
	print(slashArea.get_parent().collision_layer)
	print(slashArea.get_parent().collision_mask)
	#slashArea.disabled = false
	swordSprite.visible = true

func exit() -> void:
	#slashArea.disabled = true # for some reason seting the slash area 
	#to disabled then re enabling it doesn't work so to work around this I am not setting disabled value at all
	swordSprite.visible = false

func update(delta: float) -> void:
	# change the sword rotation to slash
	sword.rotate(slashSpeed * delta)
