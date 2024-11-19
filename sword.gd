extends Node2D
class_name Sword

const slashCD = 0.5
var slashCDLeft = slashCD

@export var stateMachine: StateMachine
@export var slashState: SlashState
@export var swordCollisionShape: CollisionShape2D
@export var sprite: Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	slashCDLeft -= delta

func slash():
	#print(swordCollisionShape.get_parent().collision_layer)
	#print(swordCollisionShape.get_parent().collision_mask)
	if slashCDLeft <= 0:
		slashCDLeft = slashCD
		stateMachine._on_state_transition("SlashState", null)

@onready var spinState: SpinState = get_node("StateMachine/SpinState")
@onready var noneState: State = get_node("StateMachine/NoneState")
func toggleSpinning():
	if stateMachine.current_state == spinState:
		stateMachine._on_state_transition("NoneState", spinState)
	else: 
		stateMachine._on_state_transition("SpinState", noneState)
