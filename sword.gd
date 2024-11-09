extends Node2D
class_name Sword

var slashSpeed = 0.3
const slashCD = 0.5
var slashCDLeft = slashCD

@export var stateMachine: StateMachine
@export var slashState: SlashState
@export var swordSprite: Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	toggleSpinning()
	toggleSpinning()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	slashCDLeft -= delta

func slash():
	if slashCDLeft <= 0:
		slashCDLeft = slashCD
		stateMachine._on_state_transition("SlashState", null)

@export var spinState: SpinState
func toggleSpinning():
	if stateMachine.current_state == spinState:
		stateMachine._on_state_transition("NoneState", null)
	else: 
		stateMachine._on_state_transition("SpinState", null)
